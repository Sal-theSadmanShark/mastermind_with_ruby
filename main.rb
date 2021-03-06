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
  puts 'invalid input , please write a valid integer' unless 1 <= mode && mode <= 4
  break if 1 <= mode && mode <= 4
end

# set game difficulty
puts 'please select the game difficult - (default is easy)'
puts '[ 1:easy(12 tries),  2:normal(8 tries),  3:hard(5 tries) ]'
i = gets.chomp
if 1 <= i.to_i && i.to_i <= 3
  turns = 12 if i == '1'
  turns = 8 if i == '2'
  turns = 5 if i == '3'
else
  turns = 12
end

# make player objects
puts 'please input the name of player1 , the code maker '
p1n = gets.chomp
p1n = 'player1' if p1n.length == 0
p1 = if mode == 1 || mode == 4
       Bot.new(p1n)
     else
       Human.new(p1n)
     end
puts 'please input the name of player2 , the code breaker '
p2n = gets.chomp
p2n = 'player2' if p2n.length == 0
p2 = if mode == 2 || mode == 4
       Bot.new(p2n)
     else
       Human.new(p2n)
     end

# set roles
p1.role = 'code_maker'
p2.role = 'code_breaker'

# take secret code from code_maker
puts
puts 'setting up the combination...'
p1.set_combination
puts

# initialize core
game = Core.new(turns, p1.name, p2.name, p1.input_slot)
puts "initializing game with #{p1.name} as the #{p1.role} and #{p2.name} as the #{p2.role} "
buffer = gets.chomp

# intro text
puts 'welcome to mastermind'
puts " this is a command line interface of the famous 70's board game 'Mastermind' "
puts 'this version uses a set of six colors to represent the pegs of the board'
puts 'each sequence must consist of four colors'
puts "and the guesser has #{turns} rounds to figure out the sequence"
puts 'the program has a lot of pauses , press enter to continue them'
puts 'press ENTER'
buffer = gets.chomp
game.play_intro

# round loop
game.play_turn_prefix
loop do
  p2.guess_combination
  p2.bot_get_similarities(game.check_similarities_for_bot(p2.input_slot, p2.id)) if p2.id == 'bot'
  break if game.play_turn_check_end?(p2.input_slot)

  puts 'next turn'
end
# end of round 1
p2.bot_reset_algo if p2.id == 'bot'
buffer = gets.chomp

# after round end set new secret code
p1.set_combination
game.set_game_combination(p1.input_slot)

# round loop
game.play_turn_prefix
loop do
  p2.guess_combination
  p2.bot_get_similarities(game.check_similarities_for_bot(p2.input_slot, p2.id)) if p2.id == 'bot'
  break if game.play_turn_check_end?(p2.input_slot)

  puts 'next turn'
end
# end of round 2
p2.bot_reset_algo if p2.id == 'bot'
buffer = gets.chomp

# start round 3 if game has not ended
unless game.check_game_over?
  p2.bot_reset_algo if p2.id == 'bot'
  #  new secret code
  p1.set_combination # take secret code from p1
  game.set_game_combination(p1.input_slot)

  # round loop
  game.play_turn_prefix
  loop do
    p2.guess_combination
    p2.bot_get_similarities(game.check_similarities_for_bot(p2.input_slot, p2.id)) if p2.id == 'bot'
    break if game.play_turn_check_end?(p2.input_slot)

    puts 'next turn'
  end
end

# buffer handler
buffer = nil
print buffer

puts
puts
puts 'The game has ended'
puts 'thanks for playing'
puts
puts '  :D  '
puts
# game end
