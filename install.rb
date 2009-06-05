#!/usr/bin/ruby

require 'rubygems'

require 'Colorify'

class AutoInstall
  include Colorify

  def install
    print colorBlack("Initial host to be monitored: ")
    monitored = STDIN.gets.chomp
    print colorBlack("Host to install web monitoring on: ")
    monitoring = STDIN.gets.chomp

    puts colorRed("sorry! auto-install does not work as of yet!")

  end

end

ai = AutoInstall.new
ai.install
