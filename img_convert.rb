#!/usr/bin/env ruby
require "nokogiri"
require "pry"

# opens every file in the given dir tree and converts any html img tags to rails image_tag calls
#
# example usage:
# ruby convert.rb ~/my_rails_app/app/views
#
# ***be careful and backup before using this***
#

raise "no directory tree given" if ARGV.first.nil?

path = "#{ARGV.first}/**/*"

@count = {
  :files_open => 0,
  :files_revised => 0,
  :tags => 0
}

class RailsImageTag

  Params = [
    { :name => :alt },
    { :name => :style },
    { :name => :class },
    { :name => :height, :type => :int },
    { :name => :width, :type => :int }
  ]

  def initialize(img)
    @img = img
  end

  # construct and return the erb containing the new image_tag call
  def to_erb
    url = @img['src']
    #url.gsub!("/images/", "")
    #url.gsub!("images/", "")
    "<%= image_tag('#{url}'#{options_to_erb}) %>"
  end

  # convert the img tag params to image_tag options
  # the params to process are defined in the Params constant hash
  def options_to_erb
    options_erb = {}
    Params.each do |opt|
      name = opt[:name]
      value = @img[name]
      value = opt[:type] != :int ? "'#{value}'" : value
      value = nil if value == "''"
      options_erb[name] = ":#{name} => #{value}" if value
    end
    options_erb.empty? ? "" : ", " + options_erb.values.join(", ")
  end

end

class HtmlDoc

  def initialize(filename)
    @name = filename
    file = File.open(@name)
    @doc = Nokogiri::HTML(file)
    @content = File.open(@name) { |f| f.read }
  end

  # overwrite the file with new contents
  def write_file(log)
    log[:files_revised] += 1
    File.open(@name, "w") {|f| f.write(@content) }
  end

  # convert a single file and record stats to <em>log</em>
  def convert_img_tags!(log)
    log[:files_open] += 1
    file_marked = false
    @doc.xpath("//img").each do |img|
      file_marked = true
      log[:tags] += 1
      original = img.to_html #.gsub("\">", "\" />").gsub("\" >", "\" />").delete("\\")
      @content.gsub!(original, RailsImageTag.new(img).to_erb)
    end
    write_file(log) if file_marked
  end

end

Dir.glob(path).each { |filename| HtmlDoc.new(filename).convert_img_tags!(@count) if File.file?(filename) }

p "***********************************"
p "#{@count[:files_open]} files opened"
p "#{@count[:files_revised]} files revised"
p "#{@count[:tags]} tags replaced"
