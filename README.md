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

## Commandline access:
* Clone this repository
* Ask for access rights to heroku
* `heroku run console` in project root folder

## Deploying

1. Push to master branch of this repository
2. Travis will deploy code to heroku if all tests pass
3. (do not push directly to heroku)

Database migrations:
[RoR-course has instructions](https://github.com/mluukkai/WebPalvelinohjelmointi2017/blob/master/web/viikko1.md)
* You need commandline access to heroku to run db:migrate
* `heroku git:clone -a pure-inlet-98383`
* `heroku run rake db:migrate`
* `heroku run rake db:seed`

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
rspec spec
```
If you don't have rspec, install it with command 
```
bundle install
```
