require 'sinatra/base'
require 'sinatra/flash'
require './lib/hangperson_game.rb'

class HangpersonApp < Sinatra::Base
  enable :sessions
  register Sinatra::Flash

  before do
    @game = session[:game] || HangpersonGame.new('')
  end

  after do
    session[:game] = @game
  end

  # These two routes are good examples of Sinatrea syntax
  # to help you with the rest of the assignment
  get '/' do
    redirect '/new'
  end

  get '/new' do
    erb :new
  end

  post '/create' do
    # NOTE: don't change next line - it's needed by autograder!
    word = params[:word] || HangpersonGame.get_random_word
    # NOTE: don't change previous line - it's needed by autograder!

    @game = HangpersonGame.new(word)
    redirect '/show'
  end

  # Use existing methods in HangpersonGame to process a guess.
  # If a guess is repeated, set flash[:message] to "You have already used that letter."
  # If a guess is invalid, set flash[:message] to "Invalid guess."
  post '/guess' do
    all_guesses = [@game.guesses, @game.wrong_guesses]
    reapeated_guess_message = 'You have already used that letter.'
    invalid_guess_message = 'Invalid guess.'

    if params[:guess].empty? || /[^a-zA-Z]/ =~ params[:guess]
      flash[:message] = invalid_guess_message
      redirect '/show'
    else
      letter = params[:guess].to_s[0]
    end

    all_guesses.each  do |guesses|
      flash[:message] = reapeated_guess_message if guesses.include? letter
    end

    @game.guess letter
    redirect '/show'
  end

  # Everytime a guess is made, we should eventually end up at this route.
  # Use existing methods in HangpersonGame to check if player has
  # won, lost, or neither, and take the appropriate action.
  # Notice that the show.erb template expects to use the instance variables
  # wrong_guesses and word_with_guesses from @game.
  get '/show' do
    @status = @game.check_win_or_lose
    redirect '/win' if @status == :win
    redirect '/lose' if @status == :lose
    erb :show # You may change/remove this line
  end

  get '/win' do
    @status = @game.check_win_or_lose
    if @status == :play
      flash[:message] = 'Please select a letter to play.'
      redirect '/show'
    end
    erb :win
  end

  get '/lose' do
    @status = @game.check_win_or_lose
    if @status == :play
      flash[:message] = 'Please select a letter to play.'
      redirect '/show'
    end
    erb :lose # You may change/remove this line
  end
end
