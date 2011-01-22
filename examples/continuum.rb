require File.expand_path('../../lib/continuum', __FILE__)

servers = %w(10.0.0.1 10.0.0.2 10.0.0.3 10.0.0.4 10.0.0.5 10.0.0.6)
continuum = Continuum.new
servers.each { |s| continuum.add_server(s) }
%w(foo bar baz test key widget).each do |w|
  puts [w, continuum.get_server(w)] * ': '
end
