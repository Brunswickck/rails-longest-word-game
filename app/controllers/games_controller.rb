require "open-uri"

class GamesController < ApplicationController
  def new
    @lettersArray = []
    10.times {
      @lettersArray << ('A'..'Z').to_a.shuffle[0]
    }
  end

  def score
    if params[:guess]
      @guess = params[:guess]
      @message = score_message
    end
  end

  private

  def score_message
    if correct_letters == false
      return "Your guess contains letters not in the grid"
    elsif correct_word == false
      return "Your guess is not in the dictionary"
    else
      return "Congrats! You scored #{@guess.length} points"
    end
  end

  def correct_letters
    @array = params[:letterGrid].chars
    @guess.upcase.chars.each do |letter|
      if @array.include?(letter) # .chars turns it into an array of characters
        letterIndex = @array.find_index(letter)
        @array.delete_at(letterIndex)
      else
        return false
      end
    end
    return true
  end

  def correct_word
    @url = "https://wagon-dictionary.herokuapp.com/#{@guess}"
    @json_info = JSON.parse(URI.open(@url).read)
    if @json_info['found']
      return true
    else
      return false
    end
  end
end
