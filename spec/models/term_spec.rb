require 'rails_helper'

RSpec.describe Term, :type => :model do

  describe 'fetch' do

    let(:page)     { File.read(Rails.root.join('spec', 'fixtures', 'pages', 'Zimmerberg.html'))}
    let(:response) { Typhoeus::Response.new(code: 200, body: page) }

    it "should fetch term from wikipedia" do
      Typhoeus.stub('http://de.wikipedia.org/wiki/zimmerberg').and_return(response)
      Typhoeus.stub(/http:\/\/de.wikipedia.org\/wiki\//).and_return(Typhoeus::Response.new(code: 200, body: 'body'))
      term = Term.find_or_fetch 'zimmerberg', 'de'

      expect(term.name).to be == 'Zimmerberg'
      expect(term.language).to be == 'de'
    end

  end

end
