# lib/simplecov_custom_adapter.rb
require 'simplecov'
SimpleCov.adapters.define 'kisalli' do

  add_filter '/spec/'
  add_filter '/db/'
  add_filter 'lib/tasks/'
  add_filter '/vendor/'
  add_filter '/config/'
  add_filter '/app/mailers/'

  add_group 'Controllers', 'app/controllers'
  add_group 'Models', 'app/models'
  add_group 'Helpers', 'app/helpers'
  add_group 'Services', 'app/services'
  
end
