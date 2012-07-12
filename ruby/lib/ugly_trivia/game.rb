module UglyTrivia
  class Game
    QUESTIONS_COUNT = 50
    MIN_PLAYERS = 2

    def  initialize
      @players = []
      @places = Array.new(6, 0)
      @purses = Array.new(6, 0)
      @in_penalty_box = Array.new(6, 0)

      @questions = {
        "Pop" => [],
        "Science" => [],
        "Sports" => [],
        "Rock" => []
      }

      @current_player = 0
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
      @players.push player_name
      @places[how_many_players] = 0
      @purses[how_many_players] = 0
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

      if @in_penalty_box[@current_player]
        if roll % 2 != 0
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
      @places[@current_player] = place % 12
    end

    def current_player_place
      @places[@current_player]
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
      @players[@current_player]
    end

    public

    def was_correctly_answered
      if @in_penalty_box[@current_player]
        if @is_getting_out_of_penalty_box
          puts 'Answer was correct!!!!'
          @purses[@current_player] += 1
          puts "#{current_player} now has #{@purses[@current_player]} Gold Coins."

          winner = did_player_win()
          @current_player += 1
          @current_player = 0 if @current_player == @players.length

          winner
        else
          @current_player += 1
          @current_player = 0 if @current_player == @players.length
          true
        end



      else

        puts "Answer was corrent!!!!"
        @purses[@current_player] += 1
        puts "#{current_player} now has #{@purses[@current_player]} Gold Coins."

        winner = did_player_win
        @current_player += 1
        @current_player = 0 if @current_player == @players.length

        return winner
      end
    end

    def wrong_answer
      puts 'Question was incorrectly answered'
      puts "#{current_player} was sent to the penalty box"
      @in_penalty_box[@current_player] = true

      @current_player += 1
      @current_player = 0 if @current_player == @players.length
      return true
    end

    private

    def did_player_win
      !(@purses[@current_player] == 6)
    end
  end
end
