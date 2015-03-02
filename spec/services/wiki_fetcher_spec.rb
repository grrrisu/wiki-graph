require 'rails_helper'

RSpec.describe WikiFetcher, :type => :model do

  subject { WikiFetcher.new }

  it "should fetch page from wikipedia" do
    response = Typhoeus::Response.new(code: 200, body: 'body')
    #Typhoeus.stub('http://de.wikipedia.org/w/index.php', params: {title: 'Zimmerberg', action: 'edit'}).and_return(response)
    Typhoeus.stub('http://de.wikipedia.org/wiki/Zimmerberg').and_return(response)

    expect(subject.fetch_term('Zimmerberg')).to eql(response)
  end

end
