class Players
  COLORS = ['red', 'green', 'blue', 'yellow', 'violet', 'orange'].freeze
  REF = ['r', 'g', 'b', 'y', 'v', 'o'].freeze
  ROLES = ['code_maker', 'code_breaker'].freeze

  def set_combination(id = @id)
    puts 'ERROR' if @role != 'code_maker'
    bot_code_generator if id == 'bot'
    print_input_getter if id == 'human'
  end

  def guess_combination(id = @id)
    if id == 'human'
      print_input_getter
    elsif id == 'bot'
      bot_guess_prefix
      bot_filter_guesslist
      bot_guess
    end
  end

  private

  def verify_player_input(input)
    if input.is_a?Integer
      input = input.to_s.split("")
      return true if input.all? { |v| 0 < v.to_i && v.to_i < 7 }
    elsif input.is_a?Array
      return true if input.all? { |v| REF.include?(v) }
    end
    false
  end
end



class Human < Players
  attr_reader :name, :id, :input_slot, :role
  attr_accessor :role

  def initialize(name = 'hooman')
    @name = name
    @id = 'human'.freeze
    @input_slot = nil
    @role = 'none'
  end

  private

  def print_input_getter
    puts "#{name} please input a valid series of colors."
    puts "Write their first letter in lowercase."
    puts "the letters must be separated with whitespace. write 'help' for reference"
    puts '- '
    p_input = 0
    until valid?(p_input)
      p_input = gets.chomp
      if p_input == 'help'
        puts "..."
        puts "the available numbers are 'red', 'green', 'blue', 'yellow', 'violet' and 'orange'"
        puts " a valid player input will contain only the first letter in lowercase. "
        puts "they also must be separated by whitespace or 'space' "
        puts "example - 'r r r r' "
        puts "the above output translated to 'red', 'red', 'red', 'red'"
        puts
        puts "input - "
        puts
      elsif valid?(p_input) == false
        puts "invalid input please try again "
        puts "- "
      end
    end
    @input_slot = p_input.split
    puts
  end

  def valid?(p_input)
    return false unless p_input.is_a?String
    i = p_input.split
    return false if i.empty?
    return false unless i.length == 4
    verify_player_input(i)
  end
end



class Bot < Players
  attr_reader :name, :id, :input_slot
  attr_accessor :role

  S = (1111..6666).to_a.freeze

  def initialize(name = 'botman')
    @name = name
    @id = 'bot'.freeze
    @input_slot = nil
    @role = 'none'
    @similarities = nil
    @supset = S.map {|e| e}
  end

  def bot_get_similarities(n)
    @similarities = n             # @similarities = [color, white, c_input]
  end

  def bot_reset_algo
    @similarities = nil
    @supset = S.map{ |e| e }               # reset the guesslist
  end

  private

  def bot_guess_prefix
    puts
    puts "#{name} is thinking..."
    puts ".."
    puts "#{name} the bot has submitted its input"
  end

  def bot_guess
    @similarities == nil ?  @input_slot = 1234 : @input_slot = @supset.first
  end

  def bot_filter_guesslist
    return 0 if @similarities == nil
    ref_c, ref_w = @similarities
    @supset.select! do |element|
      color, white = bot_check_code(element)
      color != "has 0" && ref_c == color && ref_w == white
    end
    @supset
  end

  def bot_check_code(current_element)
    c_ref = input_slot.to_s.split("")
    c_input = current_element.to_s.split("")
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
      if v == "0"
        color = "has 0"                 # if the element has 0 in it , it will be removed from S
      end
    end
    [color, white]
  end

  def bot_code_generator                # range is 1 to 6, bot only works with integers
    code = ""
    code += (rand(6) + 1).to_s
    code += (rand(6) + 1).to_s
    code += (rand(6) + 1).to_s
    code += (rand(6) + 1).to_s
    @input_slot = code.to_i
  end
end
