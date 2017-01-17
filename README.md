# Coursemanager for kisallioppiminen.fi

### Purpose
* Teachers can follows their students progress on assignments at kisallioppiminen.fi
* Teachers can create new courses and course keys for students
* Teachers can create target schedules to motivate students

### Links to our application
* Development version running at [heroku](https://pure-inlet-98383.herokuapp.com/)  
* Development version of [kisallioppiminen.fi](kisallioppiminen.fi) running at [https://ohtukisalli.github.io/](https://ohtukisalli.github.io/)  
* See also separate [Project info repository](https://github.com/OhtuKisalli/project-info)

# Developer info

## Travis
[![Build Status](https://travis-ci.org/OhtuKisalli/kisallioppiminen.server.png)](https://travis-ci.org/OhtuKisalli/kisallioppiminen.server)

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
