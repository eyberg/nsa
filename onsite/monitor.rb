#!/usr/bin/ruby

require 'rubygems'
require 'yaml'

class SysReport
  attr_accessor :hostname
  attr_accessor :port

  def initialize
    @hostname = "myhost.com"
    @port = "4567"
  end

  # find top 5 mem/cpu hogs
  def grabtop5
    # grab 6 cause the top part is a header
    top5 = `ps -eo pcpu,pid,pmem,args | sort -k 1 -r | head -6`
    top5 = top5.split(/\n/)

    top5procs = {}

    # pop the first element of the array cause it's a header
    top5.shift

    top5.each do |process|
      prochash = {}
      ps = process.split
      
      #### debugging info...
      prochash['cpu'] = ps[0]
      
      prochash['pid'] = ps[1]

      prochash['mem'] = ps[2]

      prochash['fullname'] = ps[3]

      name = ps[3].split("/")
      name = name[name.size-1]
      prochash['name'] = name

      top5procs[prochash['name']] = prochash
    end

    return top5procs
  end

  # iterate through services and grab info && send for them
  def loadservices
    yml = YAML::load(File.open('services.yml'))
    yml.each do |el| 
      puts "grabbing info for #{el[1]['name']}"
      yml = infoFor(el[1]['regex'])
      logyml(el[1]['name'], yml)

      puts "sending info for #{el[1]['name']}"
      sendreport(el[1]['name'])
    end
  end

  # grab cpu, mem, pid info for service
  # prob want to copy our stat model over so we
  # can use it instead
  def infoFor(regex)
    info = `ps -eo pcpu,pid,pmem,args | sort -k 1 -r | grep #{regex} | head -1`
    info.split
  end

  # write yaml of stat grab to disk
  def logyml(service, yml)
    File.open("/tmp/#{service}.yml", 'w') do |f| f.write(yml) end
  end

  # should be able to use this for any info we send
  # top5 should be considered an inherent service
  def sendreport(service)
    IO.popen("curl -F #{service}=@/tmp/#{service}.yml #{@hostname}:#{@port}/update") do |f|
      @status = f.read
    end
  end

end

# start gathering info --> send it
sysr = SysReport.new
#sysr.loadservices
top5 = sysr.grabtop5

t5yml = top5.to_yaml
File.open('/tmp/top5.yml', 'w') do |f| f.write(t5yml) end

sysr.sendreport('top5')

# find mysql load
# find merb load
# find beanstalk load
# find user load
