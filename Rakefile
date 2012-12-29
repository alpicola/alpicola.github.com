# coding: utf-8

require 'rake/clean'
require 'date'

PANDOC = 'pandoc -s --smart --data-dir=. --highlight-style tango'

HTML = FileList['**/*.md'].ext('html')
HTML << 'index.html'

CLEAN.include(HTML)

task :default => HTML

file 'index.html' => FileList['posts/**/*.md'] do |t|
  posts = t.prerequisites.map {|t|
    File.open(t.to_s) {|f|
      m = [f.path.slice(/(.*)\./, 1)]
      while l = f.gets and l =~ /^%\s*/
        m << $'.chomp
      end
      m
    }
  }.sort_by {|*_, date| Date.parse(date) }.reverse

  puts "#{PANDOC} -o index.html"
  IO.popen("#{PANDOC} -o index.html", 'r+') {|f|
    posts.each do |path, title, author, date|
      f.puts "- [#{title}](#{path}) | <time>#{date}</time>"
    end
  }
end

rule '.html' => '.md' do |t|
  sh "#{PANDOC} #{t.source} -o #{t}"
end
