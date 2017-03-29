class FastController < ApplicationController
  def index
    @page_id = 'fast'

    @puzzles = Puzzle.all(10, params[:start])

    @data = produce_puzzles_fast @puzzles

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @data }
    end
  end
end
