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
      unless ["update"].include? command
        event.respond("Argument error!")
      end
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

def setnick(member,server)
  nick = member.nick
  if nick
    require 'net/http'
    source = Net::HTTP.get URI("https://mcuuid.net/?q=#{nick.scan(/\w+/i)[1]}")
    source = Net::HTTP.get URI("https://api.hypixel.net/player?key=#{ENV['HYPIXEL_KEY']}&uuid=#{source.match(/https:////crafatar.com//avatars//(\w+)/)[1]}")
    lvl = source.match(/\"bedwars_level\":([\d\.]+)/)
    nlvl = lvl[1].round.to_i
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
    server.roles.each do |role|
      name = role.name
      roles[name] = role
    end
    pres = roles[pres]
    unless member.role?(pres)
      author = member
      ["Coal","Iron","Gold","Diamond","Emerald"].each do |rname|
        author.remove_role(roles[rname])
      end
      author.add_role(pres)
    end
    d = ""
    if nlvl.to_i < 10
      d = "0"
    end
    member.nick=(nick.gsub(/\[\d+.?.?.?\]/,"["+d+nlvl.to_s+" "+star+"]"))
  end
end

$bot.typing do |event|
  setnick(event.member,event.channel.server)
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
  
  def Command.update(event, *args)
    puts API::Server.resolve_members(ENV['KEY'],event.channel.server.id).size
    API::Server.resolve_members(ENV['KEY'],event.channel.server.id).each do |mem|
      if args.include? mem.distinct
        event.respond "updating " + mem.distinct
        setnick(mem.on(event.channel.server),event.channel.server)
      end 
    end
    event.message.mentions.each do |mem|
      event.respond "updating " + mem.mention
      setnick(mem.on(event.channel.server),event.channel.server)
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
