require 'rails_helper'

RSpec.describe Term, :type => :model do

  describe 'fetch' do

    let(:page)     { File.read(Rails.root.join('spec', 'fixtures', 'pages', 'zimmerberg.html'))}
    let(:response) { Typhoeus::Response.new(code: 200, body: page) }

    it "should fetch term from wikipedia" do
      Typhoeus.stub('http://de.wikipedia.org/w/index.php', params: {title: 'zimmerberg', action: 'edit'}).and_return(response)
      term = Term.fetch 'zimmerberg', 'de'

      expect(term.name).to be == 'Zimmerberg'
      expect(term.language).to be == 'de'
    end

  end

end
