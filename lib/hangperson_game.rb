# Sets up Hangperson Game
class HangpersonGame
  attr_accessor :word, :guesses, :wrong_guesses
  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/hangperson_game_spec.rb pass.

  # Get a word from remote "random word" service

  # def initialize()
  # end

  def initialize(word)
    @word = word
    @guesses = ''
    @wrong_guesses = ''
  end

  def guess(letter)
    raise ArgumentError if letter.nil? || letter.empty? || letter.match(/\W/)
    letter.downcase!

    if @word.include? letter
      return @guesses << letter unless @guesses.include? letter
    else
      return @wrong_guesses << letter unless @wrong_guesses.include? letter
    end
    false
  end

  def word_with_guesses
    @displayed = ''

    @word.each_char do |c|
      @displayed << if @guesses.include? c
                      c
                    else
                      '-'
                    end
    end
    @displayed
  end

  def check_win_or_lose
    word_with_guesses
    if @word == @displayed
      :win
    elsif @wrong_guesses.length == 7
      :lose
    else
      :play
    end
  end

  # You can test it by running $ bundle exec irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> HangpersonGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://watchout4snakes.com/wo4snakes/Random/RandomWord')
    Net::HTTP.new('watchout4snakes.com').start { |http|
      return http.post(uri, "").body
    }
  end

end
