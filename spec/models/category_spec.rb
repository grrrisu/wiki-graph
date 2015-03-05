require 'rails_helper'

RSpec.describe Category, :type => :model do

  fixtures :all

  let(:web_game) { categories(:web_game) }
  let(:work)     { categories(:work) }
  let(:game)     { categories(:game) }
  let(:root)     { categories(:root) }

  it "should return root" do
    expect(Category.root).to be == categories(:root)
  end

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
