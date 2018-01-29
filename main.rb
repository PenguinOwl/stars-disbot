require 'discordrb'
#tba
prefix = '['
bot = Discordrb::Bot.new token: File.open("creds.txt","r+").read.strip, client_id: 407055083239505922
puts bot.invite_url
puts ARGV[0]
def command(command,event,args)
  begin
    begin
      send(command,event,*args)
    rescue ArgumentError
      event.respond("Argument Error!!!1!!")
    end
  rescue NoMethodError
    event.respond("That's Not A Command!™")
  end
end

bot.message(start_with: prefix) do |event|
  puts "caught command"
  cmd = event.message.content.downcase.strip
  cmd[0] = ""
  cmd = cmd.split(" ")
  top = cmd[0]
  cmd.delete_at(0)
  puts top
  command(top, event, cmd)
end

bot.ready do |event|
end

Thread.new {while gets=="stop" do bot.stop end}

  #-----------------------------
  #          COMMANDS
  #-----------------------------

  def rubber(event)
    event.respond("woot")
  end

  def ispaulgreat(event)
    event.respond("yea " + event.author.mention)
  end


  #-----------------------------
  #       END OF COMMANDS
  #-----------------------------

  bot.run :async

# http_server.rb
require 'socket'
server = TCPServer.new(ARGV[0].to_i)
puts p server

while session = server.accept
  request = session.gets
  puts request

  session.print "HTTP/1.1 200\r\n" # 1
  session.print "Content-Type: text/html\r\n" # 2
  session.print "\r\n" # 3
  session.print "Hello world! The time is #{Time.now}" #4

  session.close
end
