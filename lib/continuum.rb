require 'digest/md5'

class Continuum
  def initialize
    @continuum, @cnt = [nil], 0
  end

  def add_server(server)
    grow if @cnt == @continuum.size
    @continuum[2 * @cnt - @continuum.size + 1], @cnt = server, @cnt + 1
  end

  def get_server(key)
    i = (Digest::MD5.hexdigest(key).hex % 360) * @continuum.size / 360
    @continuum.size.times do |j|
      s = @continuum[(i - j) % @continuum.size]
      return s unless s.nil?
    end
    nil
  end

  private
  def grow
    @continuum = Array.new(@continuum.size * 2) do |i|
      i % 2 == 0 ? @continuum[i / 2] : nil
    end
  end
end

if $0 == __FILE__
  servers = %w(10.0.0.1 10.0.0.2 10.0.0.3 10.0.0.4 10.0.0.5 10.0.0.6)
  continuum = Continuum.new
  servers.each { |s| continuum.add_server(s) }
  %w(foo bar baz test key widget).each do |w|
    puts [w, continuum.get_server(w)] * ': '
  end
end
