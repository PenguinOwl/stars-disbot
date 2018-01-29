require 'discordrb'
#tba
prefix = '['
bot = Discordrb::Bot.new token: ENV['key'], client_id: 407055083239505922
puts bot.invite_url
puts ARGV[0]
def command(command,event,args)
  begin
    begin
      Command.send(command,event,*args)
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

class Command

  #-----------------------------
  #          COMMANDS
  #-----------------------------

  def rubber(event)
    event.respond("woot")
  end

  def ispaulgreat(event)
    event.respond("yea " + event.author.mention)
  end

  def setplaying(event, text)
    if event.author.distinct=="PenguinOwl#3931"
      bot.game= text
    else
      event.respond "but ur not penguin"
    end
  end

  #-----------------------------
  #       END OF COMMANDS
  #-----------------------------

end
  
bot.run 
