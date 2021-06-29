#this is the main file. run this to play the game
require_relative "player.rb"
require "byebug"
$Game = Players.new()
def ask_user
    puts "please type the number of players"
    num_players = gets.chomp.to_i
    i = 0
    while i < num_players
        puts " "
        puts "please type the name of player " + (i + 1).to_s
        name = gets.chomp

        if name.include?(" ")
            puts "invlaid username, please try again"
            redo
        end

        $Game.players << name
        i += 1
    end

    puts "\n"
    puts "would you like to play against the computer?"

    status = gets.chomp

    if status == "yes"
        $Game.players << "ai"
    end

    $Game.take_turn($Game.current_player)
end

ask_user
