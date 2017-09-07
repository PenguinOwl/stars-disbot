require "discordrb"
#tba
puts "hi"
bot = Discordrb::Bot.new token: 'RnMZ3_G2ydLoYM7QFLf9aH0uyI2bvF_-NBVwRj6Vr1Gb4gJ4vT27AGM5FEenSuhKmV6r', client_id: 355460755627442177
bot.message(content: 'Ping!') do |event|
  event.respond 'Pong!'
end
bot.run
