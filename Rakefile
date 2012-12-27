# coding: utf-8

require 'rake/clean'
require 'date'

PANDOC = 'pandoc -s --smart --data-dir=. --highlight-style tango'

HTML = FileList['**/*.md'].ext('html')
HTML << 'index.html'

CLOBBER.include(HTML)

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

  puts "#{PANDOC} -V type=index -o index.html"
  IO.popen("#{PANDOC} -V type=index -o index.html", 'r+') {|f|
    posts.each do |path, title, author, date|
      f.puts <<-EOS.gsub(/^ {8}/, '')
        - [#{title}](#{path}) |
          <time datetime="#{Date.parse(date)}">#{date}</time>
      EOS
    end
  }
end

rule '.html' => '.md' do |t|
  sh "#{PANDOC} -V type=post #{t.source} -o #{t}"
end
