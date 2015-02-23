require 'rails_helper'

RSpec.describe WikiExtractor, :type => :model do

  subject { WikiExtractor.new(html) }

  let(:html)    { File.read(Rails.root.join('spec', 'fixtures', 'pages', 'zimmerberg.html')) }
  let(:markup)  { File.read(Rails.root.join('spec', 'fixtures', 'markups', 'zimmerberg.txt'))}

  it "should extract markup" do
    expect(subject.extract_markup).to eql(markup)
  end

  it "should extract name" do
    expect(subject.extract_name).to eql('Zimmerberg')
  end

end
