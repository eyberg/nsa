require 'rubygems'
require 'sinatra'
require 'datamapper'

require 'models/Stat'
require 'models/Host'
require 'models/Service'

username = "username"
password = "password"

# make sure we have created our db first..
DataMapper::setup(:default, "mysql://#{username}:#{password}@127.0.0.1/nsa")

load 'controllers/services.rb'
load 'controllers/reports.rb'

get '/hosts' do
  @hosts = Host.all
  haml :hosts
end

get '/admin' do
  haml :admin
end

post '/update' do
  #require 'ruby-debug'
  #debugger
  ip = request.env['REMOTE_ADDR']
  host = Host.first(:ip => ip)
  if host.nil? then
    host = Host.new
    host.ip = ip
    host.save
  end

  # should be set to the milliseconds diff.
  # from created_at --> now
  host.uptime = 1
  host.save

  json = params[:top5][:tempfile].readlines.join

  json = YAML::load(json)

  json.each do |process|
    stat = Stat.new
    stat.name = process[1]['name']
    stat.fullname = process[1]['fullname']
    stat.pid = process[1]['pid']
    stat.cpu = process[1]['cpu']
    stat.mem = process[1]['mem']
    stat.save
  end

  'got it'
end
