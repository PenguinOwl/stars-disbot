require 'discordrb'
#tba
prefix = '='
puts "key", ENV['KEY']
$bot = Discordrb::Bot.new token: ENV['KEY'].strip, client_id: ENV['CLIENT'].strip
puts $bot.invite_url
def command(command,event,args)
  begin
    begin
      Command.send(command,event,*args)
    rescue ArgumentError
      event.respond("Argument error!")
    end
  rescue NoMethodError
    event.respond("That's not a command!")
  end
end

$bot.message(start_with: prefix) do |event|
  puts "caught command"
  cmd = event.message.content.downcase.strip
  cmd[0] = ""
  cmd = cmd.split(" ")
  top = cmd[0]
  cmd.map! {|e| e.gsub("_"," ")}
  cmd.delete_at(0)
  puts top
  command(top, event, cmd)
end

$bot.message do |event|
  puts "hallo"
  nick = event.author.nick
  if nick
    event.respond(nick)
    require 'net/http'
    source = Net::HTTP.get('plancke.io', '/hypixel/player/stats/#{nick.match(/\w+/)}')
    lvl = source.match(/Current Level:<\/b> (\d+)/)
    puts lvl
    event.author.nick=(nick.gsub(/\[\d+⭐?\]/,"["+lvl[1]+"⭐]"))
    puts nick
  end
end

$bot.ready do |event|
end

Thread.new {while gets=="stop" do $bot.stop end}

class Command

  #-----------------------------
  #          COMMANDS
  #-----------------------------

  def Command.setplaying(event, text)
    if event.author.distinct=="PenguinOwl#3931"
      $bot.game= text
    else
      event.respond "but ur not penguin"
    end
  end
  
  def Command.>(event, *args)
    if event.author.distinct=="PenguinOwl#3931"
      puts args.join " "
      event.respond eval args.join(" ")
    else
      event.respond "boi stop tryn to hack me"
    end
  end

  #-----------------------------
  #       END OF COMMANDS
  #-----------------------------

end
  
$bot.run 
