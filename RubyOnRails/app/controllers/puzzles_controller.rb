class PuzzlesController < ApplicationController

  before_filter :require_login
  skip_before_filter :require_login, :only => [:show]

  def new
    @page_id = 'create_puzzle'
    @puzzle = Puzzle.new
    @puzzle.tag_names = Array.new
  end

  def create

    @puzzle = Puzzle.new(params[:puzzle])

    if remotipart_submitted?
      # ajax upload the image first, then add tag name
      @puzzle.save

      respond_to do |format|
        format.js
      end
    else
      if params[:puzzle][:puzzle_type] == 'image'
        if 'upload' == params[:image_from]
          @puzzle = Puzzle.find(params[:puzzle_id])
          @puzzle.saved = true

          respond_to do |format|
            if @puzzle.update_attributes(params[:puzzle])
              format.html { redirect_to @puzzle }
              format.json { render json: @puzzle, status: :created, location: @puzzle }
            else
              format.html { render action: "new" }
              format.json { render json: @puzzle.errors, status: :unprocessable_entity }
            end
          end
        elsif 'url' == params[:image_from]
          if params[:crawl_img].present?
            @puzzle.remote_image_url = params[:crawl_img]
            @puzzle.saved = true

            respond_to do |format|
              if @puzzle.save
                format.html { redirect_to @puzzle }
                format.json { render json: @puzzle, status: :created, location: @puzzle }
              else
                format.html { render action: "new" }
                format.json { render json: @puzzle.errors, status: :unprocessable_entity }
              end
            end
          else
            render action: "new"
          end
        end
      else
        @puzzle.lines = '<p>' + @puzzle.lines + '</p>'
        @puzzle.lines = @puzzle.lines.gsub(/\r\n/, '</p><p>')
        @puzzle.saved = true;

        respond_to do |format|
          if @puzzle.save
            format.html { redirect_to @puzzle }
            format.json { render json: @puzzle, status: :created, location: @puzzle }
          else
            @puzzle.lines = @puzzle.lines.gsub(/<\/p><p>/, "\r\n")
            @puzzle.lines = @puzzle.lines.gsub(/<\/p>/, '')
            @puzzle.lines = @puzzle.lines.gsub(/<p>/, '')

            format.html { render action: "new" }
            format.json { render json: @puzzle.errors, status: :unprocessable_entity }
          end
        end
      end
    end

  end

  def show
    @puzzle = Puzzle.find(params[:id])

    @my_answer = current_user ? @puzzle.answers.find_by_user_id(current_user.id) : nil
  end

  def edit
    @page_id = 'edit_puzzle'
    @puzzle = Puzzle.find(params[:id])

    if @puzzle.user.id != session[:user_id]
      redirect_to root_path
    end

    if @puzzle.puzzle_type == 'lines'
      @puzzle.lines = @puzzle.lines.gsub(/<\/p><p>/, "\r\n")
      @puzzle.lines = @puzzle.lines.gsub(/<\/p>/, '')
      @puzzle.lines = @puzzle.lines.gsub(/<p>/, '')
    end

  end

  def update
    @puzzle = Puzzle.find(params[:id])

    if @puzzle.user_id != session[:user_id].to_s
      redirect_to root_url
    end

    if params[:puzzle][:lines].present?
      params[:puzzle][:lines] = '<p>' + params[:puzzle][:lines] + '</p>'
      params[:puzzle][:lines] = params[:puzzle][:lines].gsub(/\r\n/, '</p><p>')
    end

    respond_to do |format|
      if @puzzle.update_attributes(params[:puzzle])
        format.html { redirect_to @puzzle, notice: (t :update_success)}
        format.json { head :no_content }
      else
        if params[:puzzle][:lines].present?
          @puzzle.lines = @puzzle.lines.gsub(/<\/p><p>/, "\r\n")
          @puzzle.lines = @puzzle.lines.gsub(/<\/p>/, '')
          @puzzle.lines = @puzzle.lines.gsub(/<p>/, '')
        end

        format.html { render action: 'edit'}
        format.json { render json: @puzzle.errors, status: :unprocessable_entity }
      end
    end
  end

  def disable
    @puzzle = Puzzle.find(params[:id])

    if @puzzle.user.id == session[:user_id]

      respond_to do |format|
        if @puzzle.update_attributes({:disable => true})
          format.json { render json: {:status => 0} }
        end
      end
    end
  end

  def like
    @puzzle = Puzzle.find(params[:id])
    @user = User.find(session[:user_id])

    if @user.voted_up_on? @puzzle
      @user.unlike @puzzle
    else
      @puzzle.liked_by @user
    end

    respond_to do |format|
      format.json { render json: {:status => 0} }
    end
  end

  def crawl_images
    url = params[:url]
    url = 'http://' + url if url.index('http://') == nil

    doc = Nokogiri::HTML(open(url))
    @data = Array.new

    doc.search('img').each do |img|
      @data.push img['src']
    end

    respond_to do |format|
      format.json { render json: {:status => 0, :images => @data} }
    end
  end

end
