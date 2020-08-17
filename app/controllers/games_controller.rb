require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = ("A".."Z").to_a.sample(10)
  end

  def score
    @answer = params[:answer].upcase
    @letters = params[:letters].split(" ")
    if english_word?(@answer) == false && included?(@answer, @letters) == true
      @score = 0
      @message = "Sorry but #{@answer} does not seem to be a valid English word..."
    elsif included?(@answer, @letters) == false && english_word?(@answer) == true
      @score = 0
      @message = "Sorry but #{@answer} can't be built out of #{@letters}"
    elsif included?(@answer, @letters) == false && english_word?(@answer) == false
      @score = -100
      @message = "#{@answer} is not valid according to the grid and is not a valid word"
    else
      @score = 100
      @message = "Congratulations! #{@answer} is a valid English word!"
    end
  end

  private

  def english_word?(word)
    response = open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    return json['found']
  end

  def included?(guess, grid)
    guess.chars.all? { |letter| guess.count(letter) <= grid.count(letter) }
  end
end
