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
    i = Digest::MD5.hexdigest(key).slice(0, 4).hex * @continuum.size / 0x10000

    # If we don't allow for servers with nil identifiers then the correct
    # server can be found in O(1) time using the following:
    # @continuum[i] || @continuum[(i + 1) % @continuum.size]

    @continuum.size.times do |j|
      s = @continuum[(i + j) % @continuum.size]
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
