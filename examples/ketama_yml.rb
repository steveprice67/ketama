require 'yaml'
require File.expand_path('../../lib/ketama', __FILE__)

servers = YAML::load(File.open(File.dirname(__FILE__) + "/servers.yml"))
continuum = Ketama.new(servers)
%w(foo bar baz test key widget).each do |w|
  puts [w, continuum.get_server(w)] * ': '
end
