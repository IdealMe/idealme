class SendHipchatMessage
  attr_reader :client

  def initialize
    @client = HipChat::Client.new ENV['HIPCHAT_AUTH_TOKEN']
  end

  def self.send(msg, notify = false)
    new.client['notifications'].send('idealme.com', msg, notify: (notify ? 1 : 0))
  end
end
