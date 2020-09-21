class Core
  attr_reader :code_breaker, :code_maker

  COLOR_SET = %w[red green blue yellow violet orange].freeze
  def initialize(turns = 12, code_maker = 'bot', code_breaker = 'human', secret_code)
    @code_maker = code_maker
    @code_breaker = code_breaker
    @secret_code = secret_code
    @game_status = 'start'
    @round_num = 1
    @turn_num = 1
    @code_maker_score = 2               # one variable for both player score tracking . 0 for lose, 4 for win
    @turns = turns.freeze
  end

  def check_game_over?
    @game_status == 'over'
  end

  def play_intro
    print_introduction
  end

  def play_turn_prefix
    puts "it's #{code_breaker}'s turn "
    puts 'make a guess '
    puts
  end

  def play_turn_check_end?(inp) # plays a turn and check if round has ended
    print_turn(inp) == 1
  end

  # if play_turn_check_end() == "1", new_secret_code() must be initialized

  def set_game_combination(code)
    puts 'ERROR' if @round_num == 1
    set_new_code(code)
  end

  # BOT METHODS
  def check_similarities_for_bot(bot_input, id)
    check_code(bot_input) if id == 'bot'
  end

  private

  def print_introduction
    puts 'the first game has started '
    puts "#{code_maker} has set the sequence"
    puts "#{code_breaker} has #{@turns} rounds to guess the sequence "
    puts "the available colors are #{COLOR_SET} "
    puts 'press enter to continue'
    buffer = gets.chomp
    puts
    buffer
  end

  def print_turn(player_input)          # takes int or color ref array and prints turn info into screen
    puts "#{code_breaker} has #{@turns - @turn_num} turns left "
    puts
    puts 'the code is being checked'
    buffer = gets
    pegs_arr = check_code(player_input) # pegs_arr = [colored pegs, white pegs, input array in color]
    color, white, player_input = pegs_arr
    puts "the submitted input : #{player_input}"
    @turn_num += 1
    color_output_cases(color, white, buffer)
  end

  def color_output_cases(color, white, _buffer = nil)
    case
    when color == 4
      puts "congratulations! #{code_breaker} cracked the code !!"
      puts
      buffer = gets
      @code_maker_score -= 1
      print_round
      return 1
    when color == 0 && white == 0
      puts 'there are no similarities'
      if (@turns - @turn_num) == 0
        round_lost
        return 1
      end
      buffer = gets
    else
      puts "the number of coloured pegs is #{color}"
      puts "the number of white pegs is #{white}"
      if (@turns - @turn_num) == 0
        round_lost
        return 1
      end
      buffer = gets
    end
    0
  end

  def round_lost
    puts
    puts "round over! #{code_breaker} has lost"
    puts
    @code_maker_score += 1
    print_round
  end

  def print_round                       # changes stats and prints the game round after every win / lose
    puts
    puts "end of round #{@round_num}"
    puts '---------------------------------------------------------------------'
    puts
    buffer = gets
    buffer = nil
    if @round_num == 3 || @code_maker_score == 0 || @code_maker_score == 4
      puts "#{code_breaker} wins this game !!" if @code_maker_score < 2
      puts "#{code_maker} wins this game !!" if @code_maker_score > 2
      buffer = gets
      @game_status = 'over'             # this indicates game over
      return 0
    end
    puts "if #{code_maker} loses another round , #{code_breaker} wins" if @code_maker_score == 1
    puts "if #{code_maker} wins another round , #{code_breaker} loses" if @code_maker_score == 3
    puts "#{3 - @round_num} rounds left"
    puts 'setting up new round.....'
    puts
    puts 'starting round'
    puts
    puts 'setting up the new sequence '
    puts
    @round_num += 1
    @turn_num = 1
    @game_status = 'ongoing'            # this indicates the request for a new color sequence
    buffer
  end

  def set_new_code(new_code)            # changes the secret code
    if @round_num != 1
      @secret_code = new_code
    else
      puts 'ERROR IN set_new_code'
    end
  end

  def check_code(player_input)          # checks the player input and returns [identical, similar, COLOR_arr]
    c_ref = @secret_code.is_a?(Integer) ? num_to_color(@secret_code) : change_c_length(@secret_code)
    c_input = player_input.is_a?(Integer) ? num_to_color(player_input) : change_c_length(player_input)
    color = 0
    white = 0
    temp = c_input.map { |e| e }
    c_ref.each_with_index do |v, i|
      next unless c_input[i] == v

      color += 1
      c_ref[i] = '0'
      temp[i] = 'zero'
    end
    temp.each do |v|
      if c_ref.include?(v)
        c_ref[c_ref.index(v)] = 'nil'
        white += 1
      end
    end
    [color, white, c_input]
  end

  def change_c_length(short_array)     # expands short human color referenced input
    ref = %w[r g b y v o]
    full_array = short_array.map { |e| e = COLOR_SET[ref.index(e)] }
    full_array
  end

  def color_to_num(color_array)        # change long color array into integer
    num = ''
    color_array.each { |c| num += (COLOR_SET.index(c) + 1).to_s }
    num.to_i
  end

  def num_to_color(color_number)       # converts integer to long color array
    colors = []
    color_number.to_s.split('').each { |n| colors.push(COLOR_SET[n.to_i - 1]) }
    colors
  end
end
