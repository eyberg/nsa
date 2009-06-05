require 'rubygems'
require 'datamapper'

require 'models/Stat'
require 'models/Host'
require 'models/Service'

username = "username"
password = "password"

# make sure we have created our db first..
DataMapper::setup(:default, "mysql://#{username}:#{password}@127.0.0.1/nsa")

# migrate our db tables if this is the first time
# otherwise right now we are just over-writing them
Stat.auto_migrate!
Host.auto_migrate!
Service.auto_migrate!
