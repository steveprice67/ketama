require 'digest/md5'

class Ketama
  def initialize(servers = [])
    @continuum = []
    servers.each do |s|
      next if s.nil?
      0.upto(39) do |i|
        digest = Digest::MD5.hexdigest([s, i] * '-')
        0.upto(3) do |j|
          @continuum[digest.slice(4 * j, 4).hex] = s
        end
      end
    end
    raise 'no servers defined' if @continuum.size == 0
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
