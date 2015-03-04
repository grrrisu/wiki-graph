require 'rails_helper'

RSpec.describe Term, :type => :model do

  describe 'fetch' do

    let(:page)     { File.read(Rails.root.join('spec', 'fixtures', 'pages', 'Zimmerberg.html'))}
    let(:response) { Typhoeus::Response.new(code: 200, body: page) }

    before :each do
      Typhoeus.stub('http://de.wikipedia.org/wiki/zimmerberg').and_return(response)
      Typhoeus.stub(/http:\/\/de.wikipedia.org\/wiki\//).and_return(Typhoeus::Response.new(code: 200, body: 'body'))
    end

    it "should fetch term from wikipedia" do  
      term = Term.find_or_fetch 'zimmerberg', 'de'
      expect(term.name).to be == 'Zimmerberg'
      expect(term.language).to be == 'de'
    end

    it "should save term when fetching" do
      term = Term.find_or_fetch 'zimmerberg', 'de'
      expect(term).to be_persisted
    end

  end

end
