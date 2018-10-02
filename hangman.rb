class Board
	@@board = ""
	@@secret_word = ""
	def choose_word
		lines = File.readlines("5desk.txt")
		new_lines = lines.map { |e| e.chomp }
		new_lines.select! {|e| e.length >= 5 && e.length <= 12}
		@@secret_word = new_lines[2]
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
		elsif @@board.kind_of?(Array)
			board = @@board.join(" ")
			puts "current board: #{board}"
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
		p @@secret_word_arr
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
		Board.modify_board(guess) if @@secret_word.include?(guess)
	end
end

class Player
	def guess_letter
		puts "Give me a letter!"
		letter = gets.chomp.downcase
		until !letter.match(/[a-z]/).nil? && letter.length == 1
			puts "Give me a letter!"
			letter = gets.chomp.downcase
		end
		Board.check_player_guess(letter)
	end	
end

board = Board.new
player = Player.new

p board.choose_word
board.create_board
Board.display_board
player.guess_letter
Board.display_board
player.guess_letter
Board.display_board