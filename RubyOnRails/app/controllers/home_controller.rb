class HomeController < ApplicationController

  def index

    @page_id = 'index'

    @puzzles = Puzzle.all(10, params[:start])

    @ajax_request_url = '/home/index.json'

    @data = produce_puzzles @puzzles

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @data }
    end
  end

  def category
    @page_id = params[:category]
    @category = t params[:category].to_sym

    puzzle_type = @page_id == 'screenshot' ? 'image' : 'lines'

    @puzzles = Puzzle.by_type(puzzle_type, 10, params[:start])
    @ajax_request_url = "/#{@page_id}.json"

    @data = produce_puzzles @puzzles

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @data }
    end
  end

  def tag
    @tag = params[:tag_name]

    @page_id = 'tag'
    @page_title = (t :tag_label) + @tag

    @puzzles = Puzzle.by_tag(@tag, 10, params[:start])
    @ajax_request_url = "/tag/#{@tag}.json"

    @data = produce_puzzles @puzzles

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @data }
    end
  end
end
