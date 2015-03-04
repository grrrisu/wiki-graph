require 'rails_helper'

RSpec.describe ContentExtractor, :type => :model do

  subject { ContentExtractor.new(html) }

  let(:html)      { File.read(Rails.root.join('spec', 'fixtures', 'pages', 'Zimmerberg.html')) }
  let(:not_found) { File.read(Rails.root.join('spec', 'fixtures', 'pages', 'not_found.html')) }
  let(:fourOfour) { File.read(Rails.root.join('spec', 'fixtures', 'pages', '404.html')) }
  
  
  it "should extract name" do
    expect(subject.name).to eql('Zimmerberg')
  end

  it "should name Suche" do
    extractor = ContentExtractor.new(not_found)
    expect(extractor.name).to be == "Spezial:Suche"
  end

  it "should extract linked terms" do
    linked_terms = subject.linked_terms
    expect(linked_terms.size).to be == 26
    expect(linked_terms.first).to be == {:name=>"Höhe_über_dem_Meeresspiegel", :text=>"Höhe"}
  end

  it "should be valid" do
    expect(subject.valid?).to be_truthy
  end

  it "should be invalid" do
    extractor = ContentExtractor.new(fourOfour)
    expect(extractor.valid?).to be_falsy
  end

end
