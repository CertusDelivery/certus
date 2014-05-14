require 'faye'
Faye::WebSocket.load_adapter('thin')

main_config = YAML.load_file("../config/config.yml")[ENV['RACK_ENV']]
FAYE_SERVER = main_config["faye_server"]

app = Faye::RackAdapter.new(:mount => '/faye', :timeout => 25)
run app
