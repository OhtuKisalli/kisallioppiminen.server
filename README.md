# Coursemanager for kisallioppiminen.fi
[![Build Status](https://travis-ci.org/OhtuKisalli/kisallioppiminen.server.png)](https://travis-ci.org/OhtuKisalli/kisallioppiminen.server) [![Coverage Status](https://coveralls.io/repos/github/OhtuKisalli/kisallioppiminen.server/badge.svg?branch=master)](https://coveralls.io/github/OhtuKisalli/kisallioppiminen.server?branch=master) [![Code Climate](https://codeclimate.com/github/OhtuKisalli/kisallioppiminen.server/badges/gpa.svg)](https://codeclimate.com/github/OhtuKisalli/kisallioppiminen.server)
### Purpose
* Teachers can follows their students progress on assignments at kisallioppiminen.fi
* Teachers can create new courses and course keys for students
* Teachers can create target schedules to motivate students

### Links to our application
* Development version running at [heroku](https://pure-inlet-98383.herokuapp.com/)  
* Development version of [kisallioppiminen.fi](kisallioppiminen.fi) running at [https://ohtukisalli.github.io/](https://ohtukisalli.github.io/)  
* See also separate [Project info repository](https://github.com/OhtuKisalli/project-info)

# Developer info

## Deploying

1. Push to master branch of this repository
2. Travis will deploy code to heroku if all tests pass
3. (do not push directly to heroku)

## Database installation and configuration
* PostgreSQL (At least version 9.3) necessary
* Database settings can be found in /config/database.yml
1) Install PostgreSQL
* `sudo apt-get update`
* `sudo apt-get install postgresql postgresql-contrib libpq-dev`
2) Create Database User kisalli
* `sudo -u postgres createuser -s kisalli`
* `sudo -u postgres psql`
* `\password kisalli`
* `Enter new password: kisalli`
* `Enter it again: kisalli`
* `\q`
3) Setup kisallioppiminen.server database
* `rake db:create`
* `rake db:setup`

## Migrations and custom seed files:
* Custom seed files (filename.rb) can be added to db/seeds/ and loaded with command `rake:db:seed:filename` (without .rb)
* `rake db:migrate`
* `rake db:seed:destroy_all` - db/seeds/destroy_all.rb (destroys database content)
* `rake db:seed:dev` - db/seeds/dev.rb (content for dev environment)

* `heroku login`
* `heroku run --app pure-inlet-98383 rake db:migrate`
* `heroku run --app pure-inlet-98383 rake db:seed:destroy_all`
* `heroku run --app pure-inlet-98383 rake db:seed:dev`
* `heroku run --app pure-inlet-98383 rails console` - to use rails console in heroku

## Ruby on Rails guides and configs

  - Ruby: 2.4.0
  - Rails: 5.0.1

Start server by issuing command: 
```
rails server
```
By default rails will be running at localhost:3000

For tests, use rspec:
```
rspec spec -fd
```
If you don't have rspec, install it with command 
```
bundle install
```
