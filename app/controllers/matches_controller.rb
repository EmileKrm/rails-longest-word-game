class MatchesController < ApplicationController

# generates a random set of letters according to the given grid size
  def game
    @grid = (1..9).map { ('A'..'Z').to_a[rand(26)] }
  end

# runs game by calling all the functions defined above
  def score
    @attempt = params[:attempt]
    @start_time = params[:start_time].to_time
    @end_time = Time.now
    @grid = params[:grid].split("")
    @result = {
      time:  @end_time - @start_time,
      translation: systran_translation(@attempt, @grid),
      score: score_table(@attempt, @grid, @start_time, @end_time),
      message: final_message(@attempt, @grid)
    }
  end

  private

  # verifies if the user's attept is an english word. Returns (True/False)
  def english_word(attempt)
    words = File.read('/usr/share/dict/words').upcase.split("\n")
    return words.include? attempt.upcase
  end

  # verifies that each letter in attempt is included in the grid
  # .all? returns true only if the condition is verified for all letters
  # .count allows us detect an error if we have the same letter in attempt
  # example: attempt = [A, A, B] and grid [A, B, C] --> count of A will be different and give false
  def valid_entry(attempt, grid)
    letters_of_attempt = attempt.upcase.split("")
    letters_of_attempt.all? do |letter|
      letters_of_attempt.count(letter) <= grid.count(letter)
    end
  end

  # guides user based on his attempt
  def final_message(attempt, grid)
    p grid
    if english_word(attempt) && valid_entry(attempt, grid)
      return "well done"
    else
      if english_word(attempt)
        return "not in the grid"
      else
        return "not an english word"
      end
    end
  end

  # translates attempt if user's attempt is valid
  def systran_translation(attempt, grid)
    if valid_entry(attempt, grid) && english_word(attempt)
      url = "https://api-platform.systran.net/translation/text/translate?source=en&target=fr&key=48ca1d8a-1aad-40fc-9085-99cba9983ec9&input=" + attempt
      translation_serialized = open(url).read
      translation = JSON.parse(translation_serialized)
      return translation["outputs"][0]["output"]
    else
      return nil
    end
  end

  # scores user's attempt based on time to answer and length of attempt
  def score_table(attempt, grid, start_time, end_time)
    if valid_entry(attempt, grid) && english_word(attempt)
      time_score = (1.fdiv(end_time - start_time) * 10)
      length_score = attempt.length * 10
      return time_score * length_score
    else
      return 0
    end
  end

  # runs game by calling all the functions defined above
  def run_game(attempt, grid, start_time, end_time)

  end
end


