module UglyTrivia
  class Player < Struct.new(:name, :purse)
  end

  class Game
    QUESTIONS_COUNT = 50
    MIN_PLAYERS = 2

    def  initialize
      @players = []
      @places = Array.new(6, 0)
      @in_penalty_box = Array.new(6, 0)

      @questions = {
        "Pop" => [],
        "Science" => [],
        "Sports" => [],
        "Rock" => []
      }

      @current_player_index = 0
      @is_getting_out_of_penalty_box = false

      QUESTIONS_COUNT.times do |i|
        @questions.each do |category, questions|
          questions.push(create_question(category, i))
        end
      end
    end

    def create_question(category, index)
      "#{category} Question #{index}"
    end

    def is_playable?
      how_many_players >= MIN_PLAYERS
    end

    def add(player_name)
      player = Player.new(player_name, 0)
      @players.push player
      @places[how_many_players] = 0
      @in_penalty_box[how_many_players] = false

      puts "#{player_name} was added"
      puts "They are player number #{@players.length}"

      true
    end

    def how_many_players
      @players.length
    end

    def roll(roll)
      puts "#{current_player} is the current player"
      puts "They have rolled a #{roll}"

      if in_penalty_box?
        if roll.odd?
          @is_getting_out_of_penalty_box = true

          puts "#{current_player} is getting out of the penalty box"
          self.current_player_place += roll

          puts "#{current_player}'s new location is #{current_player_place}"
          puts "The category is #{current_category}"
          ask_question
        else
          puts "#{current_player} is not getting out of the penalty box"
          @is_getting_out_of_penalty_box = false
        end

      else

        self.current_player_place += roll

        puts "#{current_player}'s new location is #{current_player_place}"
        puts "The category is #{current_category}"
        ask_question
      end
    end

    def current_player_place=(place)
      @places[@current_player_index] = place % 12
    end

    def current_player_place
      @places[@current_player_index]
    end

    def current_player_purse
      @players[@current_player_index].purse
    end

    def current_player_purse=(new_purse)
      @players[@current_player_index].purse = new_purse
    end

    private

    def ask_question
      puts @questions[current_category].shift
    end

    def current_category
      return 'Pop' if [0, 4, 8].include?(current_player_place)
      return 'Science' if [1, 5, 9].include?(current_player_place)
      return 'Sports' if [2, 6, 10].include?(current_player_place)
      return 'Rock'
    end

    def current_player
      @players[@current_player_index].name
    end

    def in_penalty_box?
      @in_penalty_box[@current_player_index]
    end

    public

    def was_correctly_answered
      if in_penalty_box?
        if @is_getting_out_of_penalty_box
          puts 'Answer was correct!!!!'
          self.current_player_purse += 1
          puts "#{current_player} now has #{current_player_purse} Gold Coins."

          winner = did_player_win()
          @current_player_index += 1
          @current_player_index = 0 if @current_player_index == @players.length

          winner
        else
          @current_player_index += 1
          @current_player_index = 0 if @current_player_index == @players.length
          true
        end



      else

        puts "Answer was corrent!!!!"
        self.current_player_purse += 1
        puts "#{current_player} now has #{current_player_purse} Gold Coins."

        winner = did_player_win
        @current_player_index += 1
        @current_player_index = 0 if @current_player_index == @players.length

        return winner
      end
    end

    def wrong_answer
      puts 'Question was incorrectly answered'
      puts "#{current_player} was sent to the penalty box"
      @in_penalty_box[@current_player_index] = true

      @current_player_index += 1
      @current_player_index = 0 if @current_player_index == @players.length
      return true
    end

    private

    def did_player_win
      !(current_player_purse == 6)
    end
  end
end
