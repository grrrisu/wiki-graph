require 'rails_helper'

RSpec.describe Term, :type => :model do

  fixtures :all

  describe 'fetch' do

    let(:page)     { File.read(Rails.root.join('spec', 'fixtures', 'pages', 'Zimmerberg.html'))}
    let(:empty)    { File.read(Rails.root.join('spec', 'fixtures', 'pages', 'not_found.html'))}
    let(:response) { Typhoeus::Response.new(code: 200, body: page) }

    before :each do
      Typhoeus.stub('http://de.wikipedia.org/wiki/zimmerberg').and_return(response)
      Typhoeus.stub(/http:\/\/de.wikipedia.org\/wiki\//).and_return(Typhoeus::Response.new(code: 200, body: empty))
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

  describe "categories" do

    let(:dawning)         { terms(:dawning) }
    let(:chess)           { terms(:chess) }
    let(:strategic_game)  { categories(:strategic_game) }
    let(:web_game)        { categories(:web_game) }
    let(:game)            { categories(:game) }
    let(:work)            { categories(:work) }
    let(:root)            { categories(:root) }

    it "should group category ancestors" do
      ancestors = dawning.category_ancestors
      # [
      #   { 0: [web_game], 1: [game], 2: [root] }, 
      #   { 0: [strategic_game], 1: [game], 2: [root] },  
      #   { 0: [work], 1: [game, root], 2: [root] }
      # ]
      expect(ancestors.size).to be == dawning.categories.count

      expect(ancestors[0].keys).to be == [0,1,2]

      expect(ancestors[0][0]).to be == Set.new([strategic_game])
      expect(ancestors[0][1]).to be == Set.new([game])
      expect(ancestors[0][2]).to be == Set.new([root])
    end

    it "should intersect categories" do
      res = dawning.intersect_categories(chess)
      expect(res.size).to be == 2
      expect(res[0][0]).to be == strategic_game
      expect(res[1][0]).to be == game
    end

  end

end
