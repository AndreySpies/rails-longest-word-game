require 'open-uri'

class GamesController < ApplicationController
  def letter_generator
    alphabet = ('a'...'z').to_a
    letters = []
    10.times do
      letters << alphabet.sample
    end
    letters
  end

  def new
    @t_start = Time.now
    @letters = letter_generator
  end

  def are_included(letters, word)
    result = true
    word.each do |word_letter|
      if letters.find_index(word_letter).nil?
        result = false
      else
        index = letters.find_index(word_letter)
        letters[index] = '-'
      end
    end
    result
  end

  def word_validation(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    response = JSON.parse(open(url).read)
    response["found"]
  end

  def score
    @word = params[:word].split('')
    @letters = params[:letters].split('')
    @t_start = params[:t_start]
    @letter_checker = are_included(@letters, @word)
    @result = false
    if @letter_checker == true && word_validation(@word.join) == true
      @result = true
    end
    if @letter_checker == false
      @message = "Sorry but #{@word.join} can't be built out of #{params[:letters].upcase}"
    end
    if @letter_checker == true && @result == true
      @message = "Congragulations! #{@word.join} is a valid English word!"
    elsif @letter_checker == true && @result == false
      @message = "Sorry but #{@word.join} does not seem to be a valid English word..."
    end
  end
end
