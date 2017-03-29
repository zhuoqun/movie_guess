class ApplicationController < ActionController::Base
  protect_from_forgery

  def require_login
    if session[:user_id].nil?
      flash[:notice] = t :must_login

      respond_to do |format|
        format.html { redirect_to login_accounts_path }
        
        format.json { render json: {:status => -2} }
      end
    end
  end

  def current_user
    @current_user = nil

    if session[:user_id]
      @current_user = User.find(session[:user_id])
    elsif cookies[:user_id] && cookies[:email_hash]

      @current_user = User.find(cookies[:user_id])
      if @current_user && @current_user.email
        if @current_user.email_hash == cookies[:email_hash]
          session[:user_id] = @current_user.id
        else
          @current_user = nil;
        end
      else
        @current_user = nil;
      end

    end

    @current_user
  end

  def format_time(timestamp)
    timestamp.strftime('%Y-%m-%d %H:%M:%S')
  end

  def add_notification(user_id, contact_id, action, target_type, target_id)
    return if user_id.to_s == contact_id.to_s

    notification = Notification.new
    notification.user_id = user_id
    notification.contact_id = contact_id
    notification.action = action
    notification.target_type = target_type
    notification.target_id = target_id
    notification.save
  end

  def remove_notification(user_id, contact_id, action, target_type, target_id)
    return if user_id.to_s == contact_id.to_s

    notification = Notification.where('user_id = ? and contact_id = ? and action = ? and target_type = ? and target_id = ? and is_viewed = ?', user_id, contact_id, action, target_type, target_id, false)
    notification.first.destroy if notification.present?
  end

  def produce_puzzles (puzzles)
    data = Array.new

    puzzles.each do |puzzle|
      favorite = ''
      if session[:user_id].present?
        if current_user.voted_for? puzzle
          favorite = 'favorite'
        end
      end

      if puzzle.puzzle_type == 'image'
        data.push({:puzzle_id => puzzle.id, :favorite => favorite, :puzzle_url => puzzle_path(puzzle.id), :title => puzzle.desc, :tags => puzzle.tags, :author_url => "/#{puzzle.user.path}", :author_name => puzzle.user.user_name, :author_avatar => puzzle.user.avatar_small, :answer_cnt => puzzle.answers.count, :favorite_cnt => puzzle.likes.size, :img => puzzle.image_wall, :timestamp => format_time(puzzle.updated_at)})
      else
        data.push({:puzzle_id => puzzle.id, :favorite => favorite, :puzzle_url => puzzle_path(puzzle.id), :title => puzzle.desc, :tags => puzzle.tags, :author_url => "/#{puzzle.user.path}", :author_name => puzzle.user.user_name, :author_avatar => puzzle.user.avatar_small, :answer_cnt => puzzle.answers.count, :favorite_cnt => puzzle.likes.size, :text => puzzle.lines, :timestamp => format_time(puzzle.updated_at)})
      end
    end

    data
  end

  def produce_puzzles_fast(puzzles)
    data = Array.new

    puzzles.each do |puzzle|
      favorite = ''
      user = false
      editable = false
      answered = false

      is_my_puzzle = puzzle.user_id.to_i == session[:user_id] ? true : false;

      if session[:user_id].present?
        if current_user.voted_for? puzzle
          favorite = 'favorite'
        end

        my_answer = puzzle.answers.find_by_user_id(session[:user_id])
        if my_answer.blank?
          user = {:path => current_user.path, :user_name => current_user.user_name, :avatar => current_user.avatar_medium, :is_my_puzzle => is_my_puzzle}
        else
          is_correct = my_answer.is_best == true ? 'correct' : 'not-correct'
          answered = {:answer_id => my_answer.id, :path => current_user.path, :user_name => current_user.user_name, :avatar => current_user.avatar_medium, :content => my_answer.content, :comment_cnt => my_answer.comments.count, :timestamp => format_time(my_answer.updated_at), :answer_url => puzzle_answer_path(my_answer.puzzle, my_answer), :is_my_puzzle => is_my_puzzle, :is_correct => is_correct, :upvotes_cnt => my_answer.upvotes.size, :downvotes_cnt => my_answer.downvotes.size}
        end

        if session[:user_id].to_s == puzzle.user_id
          editable = {:edit_url => edit_puzzle_path(puzzle.id)}
        end
      end

      if puzzle.puzzle_type == 'image'
        data.push({:puzzle_id => puzzle.id, :favorite => favorite, :puzzle_url => puzzle_path(puzzle.id), :title => puzzle.desc, :tags => puzzle.tags, :editable => editable, :user => user, :answered => answered, :img => puzzle.image_wall, :timestamp => format_time(puzzle.updated_at)})
      else
        data.push({:puzzle_id => puzzle.id, :favorite => favorite, :puzzle_url => puzzle_path(puzzle.id), :title => puzzle.desc, :tags => puzzle.tags, :editable => editable, :user => user, :answered => answered, :text => puzzle.lines, :timestamp => format_time(puzzle.updated_at)})
      end
    end

    data
  end

  unless Rails.application.config.consider_all_requests_local
    rescue_from Exception, with: :render_404
    rescue_from ActionController::RoutingError, with: :render_404
    rescue_from ActionController::UnknownController, with: :render_404
    rescue_from ActionController::UnknownAction, with: :render_404
    rescue_from ActiveRecord::RecordNotFound, with: :render_404
  end

  private

  def render_404(exception)
    logger.debug "404 exception #{exception}"

    respond_to do |format|
      format.html { render template: 'errors/error_404', layout: false, status: 404 }
      format.all { render nothing: true, status: 404 }
    end
  end

end
