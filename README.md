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

To run the spec suite (includes some integration tests)

    bundle exec rake spec

