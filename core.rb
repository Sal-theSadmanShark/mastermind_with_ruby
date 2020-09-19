class Core
  attr_reader :code_breaker, :code_maker

  COLOR_SET = ['red', 'green', 'blue', 'yellow', 'violet', 'orange'].freeze
  def initialize(turns = 12, code_maker = 'bot', code_breaker = 'human', secret_code)
    @code_maker = code_maker
    @code_breaker = code_breaker
    @secret_code = secret_code
    @game_status = "start"
    @round_num = 1
    @turn_num = 1
    @code_maker_score = 2               # one variable for both player score tracking . 0 for lose, 4 for win
    @turns = turns.freeze
  end

  def check_game_over
    return true if @game_status == "over"
    false
  end

  def play_intro
    print_introduction
  end

  def play_turn_prefix
    puts "it's #{code_breaker}'s turn "
    puts "make a guess "
    puts
  end

  def play_turn_check_end(inp)          # plays a turn and check if round has ended
    print_turn(inp) == 1 ? "1" : "0"
  end

  # if play_turn_check_end() == "1", new_secret_code() must be initialized

  def set_game_combination(code)
    puts "ERROR" if @round_num == 1
    set_new_code(code)
  end

  # BOT METHODS
  def check_similarities_for_bot(bot_input, id)
    check_code(bot_input) if id == 'bot'
  end


  private

  def print_introduction
    puts "the first game has started "
    puts "#{code_maker} has set the sequence"
    puts "#{code_breaker} has #{@turns} rounds to guess the sequence "
    puts "the available colors are #{COLOR_SET} "
    puts "press enter to continue"
    buffer = gets.chomp
    puts
    puts buffer
  end

  def print_round(current_player)       # changes stats and prints the game round after every win / lose
    puts "end of round #{@round_num}"
    buffer = gets
    puts buffer
    if @round_num == 1
      puts "if #{code_maker} loses another round , #{code_breaker} wins" if @code_maker_score == 1
      puts "if #{code_maker} wins another round , #{code_breaker} loses" if @code_maker_score == 3
    elsif @round_num == 3 || @code_maker_score == 0 || @code_maker_score == 4
      puts "#{code_breaker} wins this game !!" if @code_maker_score < 2
      puts "#{code_maker} wins this game !!" if @code_maker_score > 2
      buffer = gets
      @game_status = "over"             # this indicates game over
      return nil
    end
    puts "#{3-@round_num} rounds left"
    puts "setting up new round....."
    puts
    puts "starting round"
    puts
    puts "setting up the new sequence "
    puts
    @turn_num = 1
    @round_num += 1
    @game_status = "ongoing"            # this indicates the request for a new color sequence
  end

  def print_turn(player_input)          # takes int or color ref array anr prints turn info into screen
    puts "#{code_breaker} has #{@turns-@turn_num} turns left "
    puts
    puts 'the code is being checked'
    buffer = gets
    pegs_arr = check_code(player_input) # pegs_arr = [colored pegs, white pegs, input array in color]
    color, white = pegs_arr[0], pegs_arr[1]
    puts "the sumbitted input : #{pegs_arr[2]}"
    case
    when color != 4 && (@turns-@turn_num) == 0
      puts "there are no similarities"
      buffer = gets
      puts "round over! #{code_breaker} has lost"
      puts
      @code_maker_score += 1
      print_round(code_breaker)
      return 1
    when color == 0 && white == 0
      buffer = gets
      puts "there are no similarities"
    when color == 4
      puts "congratulations! #{code_breaker} cracked the code !!"
      puts
      buffer = gets
      @code_maker_score -= 1
      print_round(code_breaker)
      return 1
    else
      puts "the number of coloured pegs is #{color}"
      puts "the number of white pegs is #{white}"
      buffer = gets
    end
    puts buffer
    @turn_num += 1
    return 0
  end

  def set_new_code(new_code)            # changes the secret code
    if @round_num != 1
      @secret_code = new_code
    else
      puts "ERROR IN set_new_code"
    end
  end

  def check_code(player_input)          # checks the player input and returns [identical, similar, COLOR_arr]
    @secret_code.is_a?(Integer) ? c_ref = num_to_color(@secret_code) : c_ref = change_c_length(@secret_code)
    player_input.is_a?(Integer) ? c_input = num_to_color(player_input) : c_input = change_c_length(player_input)
    color, white = 0, 0
    temp = c_input.map { |e| e }
    c_ref.each_with_index do |v,i|
      if c_input[i] == v
        color += 1
        c_ref[i] = "0"
        temp[i] = "zero"
      end
    end
    temp.each do |v|
      if c_ref.include?(v)
      c_ref[c_ref.index(v)] = "nil"
      white += 1
      end
    end
    [color, white, c_input]
  end

  def change_c_length(short_array)     # expands short human color referenced input
    ref = ['r', 'g', 'b', 'y', 'v', 'o']
    full_array = short_array.map { |e| e = COLOR_SET[ref.index(e)]  }
    full_array
  end

  def color_to_num(color_array)        # change long color array into integer
    num = ""
    color_array.each { |c| num += (COLOR_SET.index(c) + 1).to_s }
    num.to_i
  end

  def num_to_color(color_number)       # converts integer to long color array
    colors = []
    color_number.to_s.split("").each { |n| colors.push(COLOR_SET[n.to_i-1]) }
    colors
  end
end
