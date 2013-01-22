require 'faye'
require 'json'

server = Faye::RackAdapter.new(:mount => '/faye', :timeout => 25)

server.bind(:subscribe) do |client_id, channel|
  #Publish::send(channel, client_id)
end

server.bind(:publish) do |client_id, channel, data|
  test = JSON.parse(data.to_json)
  puts test
end

server.listen(9292)