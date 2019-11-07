require "sinatra"
require "sinatra/reloader" if development?

configure do
    enable :sessions
end

ALPHABET = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
starting_lives = 7

def generate_alphabet()
    return ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
end

WORDS = [
    "HANGMAN",
    "BONNIE",
    "PENNY",
    "TEST-STRING"
]

def new_word()
    return WORDS[rand(WORDS.length)]
end

def remove_choice(input_unplayed_array, choice_index)
    input_unplayed_array[choice_index] = ""
    return input_unplayed_array
end

def make_game_string(input_word, input_unplayed_array)
    letters = input_word.split("")
    output = ""
    letters.each_with_index do |word_letter, index|
        match = false
        input_unplayed_array.each do |unplayed_letter|
            if word_letter == unplayed_letter
                match = true
            end
        end
        if match
            output += "_"
        else
            output += word_letter
        end
        if index != letters.length-1
            output += " "
        end
    end
    return output
end

def check_lives(input_lives, input_word, input_choice_index)
    if input_lives == 0
        return 0
    end
    letters = input_word.split("")
    match = false
    letters.each do |letter|
        if letter == ALPHABET[input_choice_index]
            match = true
        end
    end
    if !match
        input_lives -= 1
    end
    return input_lives
end

get "/" do
    if params["reset"] == "true"
        session["word"] = new_word()
        session["lives"] = starting_lives
        session["unplayed_letters"] = generate_alphabet
    end
    if !session["word"]
        session["word"] = new_word()
        session["lives"] = starting_lives
        session["unplayed_letters"] = generate_alphabet
    end
    if params["choice"]
        choice_index = params["choice"].to_i
        session["unplayed_letters"] = remove_choice(session["unplayed_letters"], choice_index)
        session["lives"] = check_lives(session["lives"], session["word"], choice_index)
    end
    game_string = make_game_string(session["word"], session["unplayed_letters"])
    erb :index, :locals => {:word => session["word"], :unplayed_letters => session["unplayed_letters"], 
        :alphabet => ALPHABET, :game_string => game_string, :lives => session["lives"]}
end