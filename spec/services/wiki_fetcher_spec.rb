require 'rails_helper'

RSpec.describe WikiFetcher, :type => :model do

  subject { WikiFetcher.new }

  let(:page)    { File.read(Rails.root.join('spec', 'fixtures', 'pages', 'zimmerberg.html'))}
  let(:markup)  { File.read(Rails.root.join('spec', 'fixtures', 'markups', 'zimmerberg.txt'))}

  it "should fetch page from wikipedia" do
    response = Typhoeus::Response.new(code: 200, body: 'body')
    Typhoeus.stub('http://de.wikipedia.org/w/index.php', params: {title: 'Zimmerberg', action: 'edit'}).and_return(response)

    expect(subject.fetch_term('Zimmerberg')).to eql(response)
  end

  it "should extract markup" do
    subject.prepare_doc(page)
    expect(subject.extract_markup).to eql(markup)
  end

  it "should extract name" do
    subject.prepare_doc(page)
    expect(subject.extract_name).to eql('Zimmerberg')
  end

end
