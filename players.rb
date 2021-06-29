require_relative "hash.rb"
require "byebug"
class Players
    attr_reader :players, :fragment
    $word = ""
    $j = 0
    $i = -1
    $ghost = "GHOST"
    $hash = Hash.new(0)
    def initialize(*players)
        @players = players
        @file = File.open("words.txt")
        @fragment = ""
        @dictionary = make_hash(@file.readlines.map(&:chomp))
    end

    def valid?(char)
        if @fragment.empty?
            return true
        else
            if include_word(@fragment + char)
                return false
            end
        end

        if dictionary[fragment[0]].any? {|x| x.start_with?(@fragment + char)}
            return true
        else
            return "no"
        end

    end

    def dictionary
        @dictionary
    end

    def include_word(word)
        @dictionary[word[0]].include?(word)
    end

    def current_player
        players[$j]
    end

    def take_turn(player)
        puts "\n"
        puts "WORD :- " + $word
        puts "\n"
        if @fragment.empty?
            puts player + " please type a letter to begin the round"
        else
            puts player + ", it's your turn, please type a letter"
        end

        input = gets.chomp
        puts "---------------------------------------------------------------------------------------------------------------------"
        if input.length != 1
            puts "invalid input!"
            take_turn(player)
        else
            if valid?(input) == true
                @fragment += input
                $word += input
                self.next_player!
            elsif valid?(input) == "no"
                puts "\n"
                puts self.current_player + ", there is no word that begins with, what are you thinking smfh " + @fragment + input
                puts "\n"
                puts "---------------------------------------------------------------------------------------------------------------------"
                take_turn(self.current_player)
            elsif valid?(input) == false
                puts "\n"
                puts player + ", " + fragment + input + " is a word ._. . You have earned yourself a letter"
                puts "\n"
                puts "---------------------------------------------------------------------------------------------------------------------"
                self.loses
            end
        end

    end

    def previous_player
        players[$i]
    end

    def next_player!
        if @players.include?("ai") && $j == @players.length - 2 && @fragment.empty?
            $j = 0
            $i = -1
        elsif $j == 0
            $i = 0
            $j += 1
        elsif $j >= players.length - 1
            $j = 0
            $i = -1
        else
            $i += 1
            $j += 1
        end
        if self.current_player == "ai"
            self.ai_player
        else
            take_turn(self.current_player)
        end
    end

    def loses
        $hash[self.current_player] += 1
        $word = ""
        @fragment = ""
        self.records
    end

    def records
        if $hash[self.current_player] == $ghost.length
            puts "\n"
            puts self.current_player + "has earned all the letters of 'GHOST',they are eliminated. what a noob"
            @players.delete_at($j)
            if @players.length > 1
                puts @players.length.to_s + " players remain"
                self.next_player!
            else
                self.game_over
            end
        elsif $hash[self.current_player] == $ghost.length - 1
            puts "\n"
            puts self.current_player + "is just one letter away from being eliminated"
            self.next_player!
        else
            puts "\n"
            puts $ghost[0...$hash[self.current_player]]
            self.next_player!
        end
    end


    def game_over
        puts "\n"
        puts "GG " + @players[0] + "!!! You have won the game"
    end

    def ai_player
        i = 0
        word = ""
        while i < dictionary[@fragment[0]].length
            if dictionary[@fragment[0]].reverse[i].start_with?(@fragment) && dictionary[@fragment[0]].reverse[i].length % @players.length != 0
                word += dictionary[@fragment[0]].reverse[i]
                break
            end
            i += 1
        end

        if word.empty?
            i = 0
            while i < dictionary[@fragment[0]].length
                if dictionary[@fragment[0]].reverse[i].start_with?(@fragment)
                    word += dictionary[@fragment[0]].reverse[i]
                end
                i += 1
            end
        end

        if valid?(word[@fragment.length])
            @fragment += word[@fragment.length]
            $word += word[@fragment.length - 1]
            puts "\n"
            puts "the computer chose the letter '" + word[@fragment.length - 1] + "'"
            self.next_player!
        else
            puts "YOU SMARTASS!! You have managed to defeat the computer in this round. Congratulations"
            self.loses
        end

    end
end
