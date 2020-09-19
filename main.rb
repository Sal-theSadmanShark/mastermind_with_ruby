$stdout.sync = true
require_relative 'core.rb'
require_relative 'players.rb'
# start game

# set game type
puts 'please select the game mode -'
puts '[1:bot Vs human,  2:human Vs bot,  3:human Vs human, 4:bot Vs bot ]'
mode = 0
loop do
  mode = gets.chomp
  mode = mode.to_i
  puts "invalid input , please write a valid integer" unless 1 <= mode && mode <= 4
  break if 1 <= mode && mode <= 4
end

# make player objects
puts 'please input the name of player1 , the code maker '
n = gets.chomp
n = 'player1' if n.length == 0
if mode == 1 || mode == 4
  p1 = Bot.new(n)
else
  p1 = Human.new(n)
end
puts 'please input the name of player2 , the code breaker '
n = gets.chomp
n = 'player2' if n.length == 0
if mode == 2 || mode == 4
  p2 = Bot.new(n)
else
  p2 = Human.new(n)
end

#set roles
p1.role = 'code_maker'
p2.role = 'code_breaker'

# take secret code from code_maker
puts
puts 'setting up the combination...'
p1.set_combination
puts

# initialize core
game = Core.new(p1.name, p2.name, p1.input_slot)
puts "initializing game with #{p1.name} as the #{p1.role} and #{p2.name} as the #{p2.role} "
buffer = gets.chomp


# intro text
puts "welcome to mastermind"
puts " this is a command line interface of the famous 70's board game 'Mastermind' "
puts "this version uses a set of six colors to represent the pegs of the board"
puts "each sequence must consist of four colors"
puts "and the guesser has 12 rounds to figure out the sequence"
puts buffer
game.play_intro

#round loop
game.play_turn_prefix
loop do
  p2.guess_combination
  p2.bot_get_similarities(game.check_similarities_for_bot(p2.input_slot, p2.id)) if p2.id == 'bot'
  break if game.play_turn_check_end(p2.input_slot) == "1"
  puts "next turn"
end
# end of round 1
p2.bot_reset_algo if p2.id == 'bot'
buffer = gets.chomp


# after round end set new secret code
p1.set_combination
game.set_game_combination(p1.input_slot)

#round loop
game.play_turn_prefix
loop do
  p2.guess_combination
  p2.bot_get_similarities(game.check_similarities_for_bot(p2.input_slot, p2.id)) if p2.id == 'bot'
  break if game.play_turn_check_end(p2.input_slot) == "1"
  puts "next turn"
end
# end of round 2
p2.bot_reset_algo if p2.id == 'bot'
buffer = gets.chomp


#start round 3 if game has not ended
unless game.check_game_over
  p2.bot_reset_algo if p2.id == 'bot'
  #  new secret code
  p1.set_combiantion # take secret code from p1
  game.set_game_combiantion(p1.input_slot)

  #round loop
  game.play_turn_prefix
  loop do
    p2.guess_combination
    p2.bot_get_similarities(game.check_similarities_for_bot(p2.input_slot, p2.id)) if p2.id == 'bot'
    break if game.play_turn_check_end(p2.input_slot) == "1"
    puts "next turn"
  end
end

puts
puts
puts "The game has ended"
puts "thanks for playing"
puts
puts "  :D  "
puts
# game end
