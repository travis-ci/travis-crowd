require 'eventmachine'

class OrderStream
  @streams ||= []

  def self.call(env)
    stream = new
    @streams << stream
    env['async.close'].callback { @streams.delete(stream) }
    EM.next_tick { env['async.callback'].call [200, {'Content-Type' => 'text/event-stream'}, stream] }
    throw :async
  end

  def self.send_json(data)
    send_message(data.as_json.to_json)
    @streams.each { |s| s << data.as_json.to_json }
  end

  def self.send_message(data)
    data.split(/\n/).each { |l| send_raw("data: #{l}\n") }
    send_raw("\n")
  end

  def self.send_raw(data)
    @streams.each { |s| s << data.to_s }
  end

  include EventMachine::Deferrable

  def <<(data)
    @body_callback.call(data)
  end

  def initialize
    @body_callback = proc { |_| }
  end

  def each(&block)
    @body_callback = block
  end

  #EventMachine.schedule { EventMachine::PeriodicTimer.new(10) { send_raw "\0" } }
end
