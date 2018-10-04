require "yaml"

class Board
	@@board = ""
	@@secret_word = ""
	@@incorrect_guesses = []
	def choose_word
		lines = File.readlines("5desk.txt")
		new_lines = lines.map { |e| e.chomp }
		new_lines.select! {|e| e.length >= 5 && e.length <= 12}
		@@secret_word = new_lines.sample.downcase
	end

	def create_board
		(@@secret_word.length).times do |e|
			@@board += "_"
		end
	end	

	def self.display_board
		if @@board.kind_of?(String)
			board = @@board.split("").join(" ") 
			puts "current board: #{board}"
			puts "incorrect guesses: #{@@incorrect_guesses.join(" ")}"
		elsif @@board.kind_of?(Array)
			board = @@board.join(" ")
			puts "current board: #{board}"
			puts "incorrect guesses: #{@@incorrect_guesses.join(" ")}"
		end
	end

	def self.modify_board(guess)
		puts
		i = 0 
		guesses = []
		@@secret_word_arr = @@secret_word.split("")
		if @@board.kind_of?(String) 
			@@board_arr = @@board.split("")
		else
			@@board_arr = @@board
		end
		while i < @@secret_word_arr.length
			if @@secret_word_arr[i] == guess
				guesses << i
			end
			i += 1
		end

		guesses.each{ |e| 
			@@board_arr.insert(e,guess)
			@@board_arr.delete_at(e + 1)
		} 
		@@board = @@board_arr	
	end	

	def self.check_player_guess(guess)
		if @@secret_word.include?(guess)
			Board.modify_board(guess)
		else
			@@incorrect_guesses << guess
		end		 
	end

	def check_victory
		if @@board.kind_of?(Array)
			if @@board.join("") == @@secret_word
				return true
			else
				return false
			end
		else 
			return false
		end
	end

	def self.secret_word
		@@secret_word
	end

	def self.board
		@@board
	end

	def self.incorrect_guesses
		@@incorrect_guesses
	end
end

class Player
	def guess_letter
		puts "Give me a letter!"
		letter = gets.chomp.downcase
		until !letter.match(/[a-z]|[A-Z]/).nil? && letter.length == 1
			puts "Give me a letter!"
			letter = gets.chomp.downcase
		end
		Board.check_player_guess(letter)
	end	
end

class Moderator
	def self.play_game
		board = Board.new
		player = Player.new
		i = 12
		board.choose_word
		board.create_board
		while i > 0
			puts 
			puts "Turn #{i}"
			puts "guess or save? g/s"
			choice = gets.chomp.downcase
			if choice == "s"
				puts "name the file."
				file_name = gets.chomp.downcase
				File.open("#{file_name}.yaml", "w") { |file|  
					file.puts(Moderator.to_yaml(i))}
			end
			Board.display_board
			player.guess_letter
			if board.check_victory
				puts Board.display_board
				puts "You guessed the word! You win!"
				exit
			end
			i -= 1
		end
		puts "You lose! HAHHAHAAA!!"
		puts "The word was #{board.secret_word}"
	end	

	def self.to_yaml(turn)
		YAML.dump ({
			:board => Board.board,
			:secret_word => Board.secret_word,
			:incorrect_guesses => Board.incorrect_guesses,
			:turn => turn
		})
	end

end

Moderator.play_game