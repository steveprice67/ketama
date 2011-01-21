class Continuum
  def initialize
    require 'digest/md5'
    @c, @cnt = [nil], 0
  end

  def add_server(server)
    grow if @cnt == @c.size
    @c[2 * @cnt - @c.size + 1], @cnt = server, @cnt + 1
  end

  def get_server(key)
    i = Digest::MD5.hexdigest(key).hex % @c.size
    @c[i] || @c[(i + 1) % @c.size]
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
  %w(foo bar baz).each do |w|
    puts continuum.get_server(w)
  end
end
