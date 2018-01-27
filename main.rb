require "discordrb"
#tba
prefix = "["
bot = Discordrb::Bot.new token: 'MzU1NTA4NzI4MzQ0MDg0NTEx.DJN1kg.hqg0FnhVzEKfLE2TVl8y6naurJs', client_id: 355508728344084511

def command(command,event,args)
  catch ArgumentError
    send(command,event,*args)
  rescue
    bot.sendmessage("woow")
  end
end

bot.message(startwith: prefix) do |event|
  cmd = event.message.content
  cmd[0] = ""
  cmd = cmd.split(" ")
  top = cmd[0]
  cmd.delete_at(0)
  command(top, event, cmd)
end
bot.run
