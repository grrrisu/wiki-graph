class TemplateExtractor < WikiCloth::Parser

  attr_reader :templates

  def initialize(args = {})
    @templates = []
    super(args)
    to_html # parse the document
  end

  def extract(name)
    ret = []
    @templates.each do |template|
      ret << template[:data] if template[:name] == name
    end
    ret.length == 1 ? ret.first : ret
  end

  link_for do |url,text|
    text.blank? ? url : text
  end

  include_resource do |resource,options|
    data = {}
    options.each do |opt|
      if opt.is_a? Hash
        data[opt[:name]] = opt[:value]
      end
    end
    @templates << { :name => resource, :data => data }
    ""
  end

end
