require "sinatra"
require "sinatra/reloader" if development?

configure do
    enable :sessions
end

flash_message = ""

ALPHABET = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]

def generate_alphabet()
    return ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
end

WORDS = [
    "hangman"
]

def new_word()
    return WORDS[rand(WORDS.length)]
end

def remove_choice(input_unplayed_array, choice_index)
    input_unplayed_array[choice_index] = ""
    return input_unplayed_array
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
    word_letters = session["word"].split("")
    erb :index, :locals => {:word => session["word"], :unplayed_letters => session["unplayed_letters"], 
        :alphabet => ALPHABET, :flash_message => flash_message,:word_letters => word_letters, 
        :played_letters => session["played_letters"]}
end