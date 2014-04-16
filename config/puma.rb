module Rails
  class <<self
    def root
      File.expand_path(__FILE__).split('/')[0..-3].join('/')
    end
  end
end

basedir = Rails.root

rackup      "#{basedir}/config.ru"

port        ENV['PORT']     || 3000
environment ENV['RAILS_ENV'] || 'development'

daemonize true

pidfile     "#{basedir}/tmp/pids/puma.pid"
state_path  "#{basedir}/tmp/pids/puma.state"

stdout_redirect "#{basedir}/log/stdout", "#{basedir}/log/stderr", true

workers Integer(ENV['PUMA_WORKERS'] || 3)
threads Integer(ENV['MIN_THREADS']  || 1), Integer(ENV['MAX_THREADS'] || 16)

preload_app!

bind        "unix:///var/run/puma.certus.sock"

on_worker_boot do
  # worker specific setup
  ActiveSupport.on_load(:active_record) do
    ActiveRecord::Base.establish_connection
  end
end