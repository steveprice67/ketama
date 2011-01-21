require 'digest/md5'

class Ketama
  def initialize(servers)
    @continuum = []
    servers.each do |s|
      0.upto(39) do |i|
        digest = Digest::MD5.hexdigest([s, i] * '-')
        0.upto(3) do |j|
          @continuum[digest.slice(4 * j, 4).hex] = s
        end
      end
    end
  end

  def get_server(key)
    i = Digest::MD5.hexdigest(key).slice(0, 4).hex
    @continuum.size.times do |j|
      s = @continuum[(i + j) % @continuum.size]
      return s unless s.nil?
    end
    nil
  end
end

if $0 == __FILE__
  servers = %w(10.0.0.1 10.0.0.2 10.0.0.3 10.0.0.4 10.0.0.5 10.0.0.6)
  ketama = Ketama.new(servers)
  %w(foo bar baz test key widget).each do |w|
    puts [w, ketama.get_server(w)] * ': '
  end
end
