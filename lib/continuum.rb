require 'digest/md5'

class Continuum
  def initialize
    @c, @cnt = [nil], 0
  end

  def add_server(server)
    grow if @cnt == @c.size
    @c[2 * @cnt - @c.size + 1], @cnt = server, @cnt + 1
  end

  def get_server(key)
    i = (Digest::MD5.hexdigest(key).hex % 360) * @c.size / 360
    @c.size.times do |j|
      s = @c[(i - j) % @c.size]
      return s unless s.nil?
    end
    nil
  end

  private
  def grow
    @c = Array.new(@c.size * 2) { |i| i % 2 == 0 ? @c[i / 2] : nil }
  end
end

if $0 == __FILE__
  servers = %w(10.0.0.1 10.0.0.2 10.0.0.3 10.0.0.4 10.0.0.5 10.0.0.6)
  continuum = Continuum.new
  servers.each { |s| continuum.add_server(s) }
  %w(foo bar baz test key widget).each do |w|
    puts continuum.get_server(w)
  end
end
