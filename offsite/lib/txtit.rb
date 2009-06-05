require 'rubygems'
require 'mechanize'

agent = WWW::Mechanize.new

page = agent.get 'http://messaging.sprintpcs.com/textmessaging/compose'
form1 = page.forms.first

number = "1234567890"
msg = "site is down"
form1.recipientsNumber = number 
form1.textMessage = msg
form1.characters = "#{160-msg.size}"
agent.submit form1

