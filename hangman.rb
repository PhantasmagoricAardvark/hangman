

class Board
	@@board = ""
	@@secret_word = ""
	def choose_word
		lines = File.readlines("5desk.txt")
		new_lines = lines.map { |e| e.chomp }
		new_lines.select! {|e| e.length >= 5 && e.length <= 12}
		@@secret_word = new_lines.sample.downcase
	end

	def create_board
		(@@secret_word.length).times do |e|
			@@board += "_ "
		end
	end	

	def display_board
		@@board
	end

	def self.modify_board(guess)
		p @@board
		p @@secret_word.index(guess)
		if @@secret_word.index(guess) == 0
			index1 = 0
		elsif @@secret_word.index(guess).odd?
			index1 = @@secret_word.index(guess) + 1
		elsif @@secret_word.index(guess).even?
			index1 = @@secret_word.index(guess) * 2
		end
		p index1
		@@board.sub!(@@board[index1], guess)
		p @@board

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
player.guess_letter