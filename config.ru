#!/usr/bin/env rackup

require 'rack/rewrite'

use Rack::Rewrite do
  rewrite '/', '/index.html'
  rewrite %r{^.*/[^./]+$}, '$&.html'
end

run Rack::Directory.new('.')
