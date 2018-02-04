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
  nick = event.author.nick
  if nick
    require 'net/http'
    source = Net::HTTP.get URI("https://plancke.io/hypixel/player/stats/#{nick.match(/\w+$/i)[0]}")
    puts "https://plancke.io/hypixel/player/stats/#{nick.match(/\w+$/i)[0]}"
    lvl = source.match(/Current Level:<\/b> (\d+)/)
    nlvl = lvl[1].to_i
    pres = case nlvl
      when 0..99; "Coal"
      when 100..199; "Iron"
      when 200..299; "Gold"
      when 300..399; "Diamond"
      when 400..999; "Emerald"
    end
    star = case nlvl
      when 0..99; "⭐"
      when 100..199; "🌟"
      when 200..299; "✨"
      when 300..399; "💫"
      when 400..999; "☄️"
    end
    roles = {}
    event.server.roles.each do |role|
      name = role.name
      roles[name] = role
    end
    pres = roles[pres]
    unless event.author.role?(pres)
      author = event.author
      ["Coal","Iron","Gold","Diamond","Emerald"].each do |rname|
        author.remove_role(roles[rname])
      end
      author.add_role(pres)
    end
    event.author.nick=(nick.gsub(/\[\d+.?.?.?\]/,"["+lvl[1]+star+"]"))
  end
end

$bot.ready do |event|
end

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
