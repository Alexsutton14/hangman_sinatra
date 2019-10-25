require "sinatra"
require "sinatra/reloader" if development?

configure do
    enable :sessions
    #set :session_secret, "secret"
end

flash_message = ""

ALPHABET = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]

FULL_ALPHABET = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]


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
    @session = session
    if params["reset"] = "true"
        @session["word"] = new_word()
        @session["unplayed_letters"] = ALPHABET
    end
    if !@session["word"]
        @session["word"] = new_word()
        @session["unplayed_letters"] = ALPHABET
    end
    if !@session["unplayed_letters"]
        @session["unplayed_letters"] = ALPHABET
    end
    if params["choice"]
        choice_index = params["choice"].to_i
        choice_letter = ALPHABET[choice_index]
        @session["unplayed_letters"] = remove_choice(session["unplayed_letters"], choice_index)
        flash_message = "Removed: " + choice_letter
    end
    erb :index, :locals => {:word => @session["word"], :unplayed_letters => @session["unplayed_letters"], 
        :alphabet => FULL_ALPHABET, :flash_message => flash_message}
end