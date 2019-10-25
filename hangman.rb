require "sinatra"
require "sinatra/reloader" if development?

configure do
    enable :sessions
end

flash_message = ""

ALPHABET = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]

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

get "/" do
    if params["reset"] == "true"
        session["word"] = new_word()
        session["unplayed_letters"] = generate_alphabet
        session["played_letters"] = []
    end
    if !session["word"]
        session["word"] = new_word()
        session["unplayed_letters"] = generate_alphabet
        session["played_letters"] = []
    end
    if !session["unplayed_letters"]
        session["unplayed_letters"] = generate_alphabet
        session["played_letters"] = []
    end
    if params["choice"]
        choice_index = params["choice"].to_i
        session["unplayed_letters"] = remove_choice(session["unplayed_letters"], choice_index)
        session["played_letters"] << ALPHABET[choice_index]
    end
    game_string = make_game_string(session["word"], session["unplayed_letters"])
    erb :index, :locals => {:word => session["word"], :unplayed_letters => session["unplayed_letters"], 
        :alphabet => ALPHABET, :flash_message => flash_message,:game_string => game_string}
end