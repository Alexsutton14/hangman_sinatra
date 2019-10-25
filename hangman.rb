require "sinatra"
require "sinatra/reloader" if development?

WORDS = [
    "hangman"
]

def new_word()
    return WORDS[rand(WORDS.length)]
end

get "/" do
    new_word()
end