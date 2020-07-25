require 'set'
require 'byebug'

class Game
	attr_reader :n_guesses, :guessed_chars
	def initialize # 
		File.open("data/dict.txt", "r") do |dict|
			text = dict.read.split
			@word = text[Random.rand(text.size - 1)] # get a random word
			@word.upcase!			
		end				
		@n_guesses = 6
		@guessed_chars = Set.new
		@revealed_word = "_" * @word.length 
		@won = false
		@game_over = false
	end

	def already_guessed?(ch) #is this necessary?
		return @guessed_chars.include?(ch)
	end

	def reveal_char(index_list, ch) #take in character and indices where it occurs, then reveal those
		index_list.each do |i|			
			@revealed_word[i] = ch
		end
		puts @revealed_word.chars.join(" ")
	end

	def eval_guess(ch)
		index_list = []
		@word.each_char.with_index do |w_ch, ind|
			index_list << ind if w_ch == ch
			@guessed_chars.add(ch)
		end
		if index_list.length != 0
			# modify state of guessed word and display
			reveal_char(index_list, ch)
			if @revealed_word == @word
				@game_over = true
				@won = true
			end
		else
			# display number of guesses left & warning
			@n_guesses -= 1			
			if @n_guesses == 0 # run out of guesses
				@game_over = true
			else
				puts "\nYou have #{@n_guesses} guesses remaining!"
			end
		end
	end

	def parse_input(str)
		str.upcase!
		if str == "QUIT"
			# exit; TODO: add validation
			puts "\nQuitting..."
			exit
		elsif str == "SAVE"
			# save
			puts "\nReceived save command"			
		elsif str.length != 1
			puts "\nGuess must be a single letter or a valid command!"			
		else
			unless already_guessed?(str)
				eval_guess(str)				
			else
				puts "\nYou already guessed this letter! Try another one."								
			end
		end		
	end

	def play
		puts "You are now playing Hangman!\n"
		puts "Enter a letter to guess, otherwise enter SAVE or QUIT."
		until @game_over			
			puts "\nEnter your guess or a command:"
			cmd = gets.chomp
			#byebug
			parse_input(cmd)			
		end

		if @won
			puts "\nYou won!"
		else
			puts "\nYou lost! The word was #{@word}!"
		end
	end
end

game_obj = Game.new
game_obj.play
