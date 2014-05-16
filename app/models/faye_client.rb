require 'net/http'
class FayeClient
  def self.send(channel, params)
    Thread.new {
      message = {:channel => channel, :data => params}
      uri = URI.parse(Setting.faye_server)
      Net::HTTP.post_form(uri, :message => message.to_json)
    }
  end
end