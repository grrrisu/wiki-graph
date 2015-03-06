require 'rails_helper'

RSpec.describe Category, :type => :model do

  fixtures :all

  let(:web_game)  { categories(:web_game) }
  let(:board_game){ categories(:board_game) }
  let(:work)      { categories(:work) }
  let(:game)      { categories(:game) }
  let(:root)      { categories(:root) }

  it "should return root" do
    expect(Category.root).to be == categories(:root)
  end

  describe "ancestors" do
    
    it "should find ancestors for web_game" do
      ancestors = categories(:web_game).ancestors
      expect(ancestors).to be == {0 => Set.new([web_game]), 1 => Set.new([game]), 2 => Set.new([root])}
    end

    it "should find ancestors for web_game with names" do
      ancestors = categories(:web_game).ancestors {|c| c.name}
      expect(ancestors).to be == {0 => Set.new([web_game.name]), 1 => Set.new([game.name]), 2 => Set.new([root.name])}
    end

    it "should find ancestors for work" do
      ancestors = categories(:work).ancestors
      expect(ancestors).to be == {0 => Set.new([work]), 1 => Set.new([root, game]), 2 => Set.new([root])}
    end

  end

  it "should find common category between" do
    res = web_game.intersect(board_game)
    expect(res[0]).to be == game
    expect(res[1]).to be == 1
    expect(res[2]).to be == 1
  end

  it "should know if it is child of" do
    expect(web_game.is_child_of?(game)).to be_truthy
    expect(web_game.is_child_of?(web_game)).to be_falsy
    expect(game.is_child_of?(web_game)).to be_falsy
  end

end
