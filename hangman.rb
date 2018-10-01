

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
			@@board += "_"
		end
	end	

	def self.display_board
		if board.kind_of?(Array)
		board = @@board.split("").each { |e| e << " " }
		puts "Current: #{board.join(" ")}"
	end

	def self.modify_board(guess)
		puts 
		@@secret_word_arr = @@secret_word.split("")
		@@board_arr = @@board.split("")
		p @@secret_word_arr
		p @@board_arr
		index1 = @@secret_word_arr.index(guess)
		@@board_arr.insert(index1,guess)
		@@board_arr.delete_at(index1 + 1)
		p @@board_arr
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
player.guess_letter
Board.display_board