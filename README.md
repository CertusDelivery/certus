Certus
=======

These instructions assume the use of Mac OS X Mountain Lion

[Homebrew](http://github.com/mxcl/homebrew).

[Rbenv](https://github.com/sstephenson/rbenv) or [RVM](https://rvm.io/rvm/install/)

Documentation is rbenv specific, so swap out any rbenv command with the rvm equivalent.

For server applications such as postgres, follow the commands to start and autostart the servers upon reboot that are provided at the end of the install.


RVM
---
Install rvm per instructions at https://rvm.io/rvm/install/ and install ruby

    rvm install 2.1.0


Rbenv
-----

    brew install rbenv
    rbenv install 2.1.0
    rbenv local 2.1.0
    gem install bundler
    rbenv rehash


Bundler
-------

    gem install bundler


PostgreSQL
----------

    brew install postgres
    # Follow instructions to autostart and load
    initdb /usr/loca/var/postgres
    psql --host localhost postgres
    create role [your login] superuser login

Redis
-----

	# install
	$ wget http://download.redis.io/releases/redis-2.8.9.tar.gz
    $ tar xzf redis-2.8.9.tar.gz
    $ cd redis-2.8.9
    $ make
    
    # start
    $ redis-server redis.conf
    
    # stop
    $ kill -9 $(cat tmp/pids/puma.pid)
    

NodeJS
---

    brew install node


Karma
---

    npm install karma


Pow
---

    curl get.pow.cx | sh
    cd ~/.pow && ln -s ~/dev/[project folder]
    etc...


App Setup
---------

    git clone git@github.com:CertusDelivery/certus.git
    cd certus
    rbenv local 2.1.0
    git checkout develop
    cp config/database.yml.example config/database.yml

Update the configs as necessary.

    bundle install
    rake db:create
    rake db:setup
    rake db:seed

To run the spec suite (includes some integration tests)

    bundle exec rake spec

To run the spec features(in spec/features, file ext with .feature):

    bundle exec rake spec:features


Servicers 
---------

	1. Nginx
	2. Puma
	
		puma -C config/puma.rb -d
		 
	3. Redis
	
	   	/path/redis/redis-server /path/redis/redis.conf
	   	
	4. Sidekiq
	
		sidekiq -C config/sidekiq.yml -d -L log/sidekiq-server.log
		
	5. Faye
	
		cd faye && thin start -C thin.yml
		
Redeploy
--------

0. #### login server
		    $ ssh ~~~~
        $ cd /root/certus
1. #### kill all servers
        $ ./killpids.sh
        ------------ or kill one by one ------------
        $ kill -9 $(cat tmp/pids/puma.pid)
        $ kill -9 $(cat tmp/pids/sidekiq.pid)
        $ kill -9 $(cat tmp/pids/thin.8080.pid)
3. #### update certus code
        $ git pull [origin remote_branch]
4. #### install missing gems
        $ bundle install       
5. #### update database
        $ rake db:migrate RAILS_ENV=(dev|staging|production)
6. #### compile asset files
        $ rake assets:precompile RAILS_ENV=(dev|staging|production)
7. #### start all servers
        $ ./run.sh
        ------------ or start one by one ------------
        $ RAILS_ENV=(dev|staging|production) sidekiq -C config/sidekiq.yml -d -L log/sidekiq-server.log
        $ RAILS_ENV=(dev|staging|production) puma -C config/puma.rb -d
        $ cd faye
        $ RAILS_ENV=(dev|staging|production) thin start -C thin.yml
