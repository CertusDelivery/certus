data = File.read(File.expand_path(File.join(__FILE__, '..', 'app_config.yml')))
config = YAML.load(data)

begin
  APP_CONFIG
rescue
  APP_CONFIG = {}
end

env_config = config['defaults'].merge(config[Rails.env] || {})
env_config.symbolize_keys!

APP_CONFIG.replace(env_config)

