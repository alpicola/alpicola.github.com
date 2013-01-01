# coding: utf-8

require 'rake/clean'
require 'builder'
require 'time'

PANDOC = 'pandoc -s --smart --data-dir=.'
TITLE  = 'alpico.la'
URL    = 'http://alpico.la/'

HTML = FileList['**/*.md'].ext('html')
HTML << 'index.html'

CLOBBER.include(HTML)

task :default => :build
task :build => HTML
task :rebuild => [:clobber, :build]

rule '.html' => '.md' do |t|
  sh "#{PANDOC} #{t.source} -o #{t}"
end

file 'index.html' => FileList['posts/**/*.md'] do |t|
  posts = t.prerequisite_tasks.map {|t|
    File.open(t.name) {|f|
      m = [t.name.ext(''), t.timestamp]
      while l = f.gets and l =~ /^%\s*/
        m << $'.chomp
      end
      m
    }
  }.sort_by {|*, date| Time.parse(date) }.reverse

  puts "#{PANDOC} -o index.html"
  IO.popen("#{PANDOC} -o index.html", 'r+') {|f|
    posts.each do |path, _, title, _, date|
      f.puts "- [#{title}](/#{path}) | <time>#{date}</time>"
    end
  }

  puts 'generate feed.xml'
  File.open('feed.xml', 'w') {|f|
    xml = Builder::XmlMarkup.new(:target => f, :indent => 4)
    xml.instruct! :xml, :version => "1.0", :encoding => 'UTF-8'
    xml.feed(:xmlns => 'http://www.w3.org/2005/Atom') do
      xml.id      URL
      xml.title   TITLE
      xml.updated (t.prerequisite_tasks.map(&:timestamp).max || t.timestamp).iso8601
      xml.link :rel => 'alternate', :href => URL
      xml.link :rel => 'self', :href => URL + 'feed.xml'

      posts.each do |path, updated, title|
        xml.entry do
          xml.id      URL + path
          xml.title   title
          xml.updated updated.iso8601
          xml.link :rel => 'alternate', :href => URL + path
        end
      end
    end
  }
end
