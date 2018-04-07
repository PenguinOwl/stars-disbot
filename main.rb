require 'discordrb'
require 'hypixel-ruby'
require 'hashie'
#tba
prefix = '='
$api = HypixelAPI.new(ENV['HYPIXEL_KEY'])
puts "key", ENV['KEY']
$bot = Discordrb::Bot.new token: ENV['KEY'].strip, client_id: ENV['CLIENT'].strip
puts $bot.invite_url
def command(command,event,args)
  if ENV['DEBUG'] == "false"
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
  else
    Command.send(command,event,*args)
  end
end

$bot.message(start_with: prefix) do |event|
  puts "caught command"
  cmd = event.message.content.downcase.strip
  cmd[0] = ""
  cmd = cmd.split(" ")
  top = cmd[0]
  cmd.map! {|e| e.gsub("$$s"," ")}
  cmd.delete_at(0)
  puts top
  command(top, event, cmd)
end

def setnick(member,server)
  nick = member
  nick = member.nick if member.class != String
  if nick
    require 'net/http'
    source = Net::HTTP.get URI("https://mcuuid.net/?q=#{nick.scan(/\w+/i)[1]}")
    uuid = source.match(/https:\/\/crafatar.com\/avatars\/(\w+)/)[1]
    source = $api.player(:uuid => uuid)
    lvl = source.deep_find(:bedwars_level).to_i - 1
    nlvl = lvl
    pres = case nlvl
      when 0..99; "Coal"
      when 100..199; "Iron"
      when 200..299; "Gold"
      when 300..399; "Diamond"
      when 400..499; "Emerald"
      when 500..599; "Sapphire"
      when 600..999; "Ruby"
    end
    star = case nlvl
      when 0..99; "⭐"
      when 100..199; "🌟"
      when 200..299; "✨"
      when 300..399; "💫"
      when 400..499; "☄️"
      when 500..599; "✫"
      when 600..999; "⚡"
    end
    roles = {}
    server.roles.each do |role|
      name = role.name
      roles[name] = role
    end
    pres = roles[pres]
    unless member.class == String or member.role?(pres)
      author = member
      unless member.roles == [] or member.roles == nil
        ["Coal","Iron","Gold","Diamond","Emerald","Sapphire","Ruby"].each do |rname|
          author.remove_role(roles[rname])
        end
      end
      author.add_role(pres)
    end
    d = ""
    if nlvl.to_i < 10
      d = "0"
    end
    res = nick.gsub(/\[\d+.?.?.?\]/,"["+d+nlvl.to_s+star+"]")
  end
  res
end

$bot.typing do |event|
  event.member.nick = setnick(event.member,event.channel.server)
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
    event.message.mentions.each do |mem|
      event.respond "updating " + mem.mention
      mem.nick = setnick(mem.on(event.channel.server), event.channel.server)
    end
  end
  
  def Command.total(event)
    total = 0
    event.channel.server.members.each do |mem|
      if mem.nick
        str = mem.nick.match(/\[(\d+)\s?.?\]\s.+/i)
        if str
          total = str[1].to_i + total
        end
      end
    end
    event.respond total.to_s + " total stars."
  end
  
  def Command.%(event, *args)
    event.respond setnick(args.join(" "),event.channel.server)
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
