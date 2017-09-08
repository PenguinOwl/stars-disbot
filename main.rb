require "discordrb"
#tba
puts "hi"
bot = Discordrb::Bot.new token: 'MzU1NTA4NzI4MzQ0MDg0NTEx.DJN1kg.hqg0FnhVzEKfLE2TVl8y6naurJs', client_id: 355508728344084511
bot.message(content: 'Ping!') do |event|
  event.respond 'Pong!'
end
bot.run
