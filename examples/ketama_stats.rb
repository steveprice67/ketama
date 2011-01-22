require File.expand_path('../../lib/ketama', __FILE__)

class Ketama
  def display_stats
    prev, work = 0, Hash.new { |h, k| h[k] = 0 }
    @continuum.each_with_index do |s, p|
      next if s.nil?
      work[s] += p - prev
      prev = p
    end
    work.keys.sort.each do |s|
      puts [s, '%.2f' % (work[s].to_f / prev * 100)] * ': '
    end
  end
end

servers = %w(10.0.0.1 10.0.0.2 10.0.0.3 10.0.0.4 10.0.0.5 10.0.0.6)
continuum = Ketama.new(servers)
continuum.display_stats
%w(foo bar baz test key widget).each do |w|
  puts [w, continuum.get_server(w)] * ': '
end
