class AnswersController < ApplicationController
  before_filter :require_login, :only => [:create, :update, :upvote, :downvote]

  def index
    puzzle = Puzzle.find(params[:puzzle_id])

    is_my_puzzle = false

    if (puzzle.user_id.to_i == session[:user_id])
      is_my_puzzle = true
    end

    @data = Array.new

    puzzle.answers.order('is_best DESC, cached_votes_up DESC').each do |answer|

      if session[:user_id].present?
        next if answer.user_id.to_i == session[:user_id]

        voted_up = current_user.voted_up_on?(answer) ? 'voted' : false
        voted_down = current_user.voted_down_on?(answer) ? 'voted' : false
      else
        voted_up = voted_down = false
      end

      is_correct = 'not-correct'
      if answer.is_best == true
        is_correct = 'correct'
      end

      @data.push({:answer_id => answer.id, :content => answer.content, :user_url => "/#{answer.user_id}", :user_avatar => answer.user.avatar.url, :user_name => answer.user.user_name, :voted_up => voted_up, :voted_down => voted_down, :upvotes_cnt => answer.upvotes.size, :downvotes_cnt => answer.downvotes.size, :comment_cnt => answer.comments.count, :answer_url => puzzle_answer_path(answer.puzzle, answer), :timestamp => format_time(answer.created_at), :is_my_puzzle => is_my_puzzle, :is_correct => is_correct})
    end

    respond_to do |format|
      format.json { render json: @data }
    end

  end

  def show
    @puzzle = Puzzle.find(params[:puzzle_id])
    @answer = Answer.find(params[:id])

    render 'show', :layout => 'puzzles'
  end

  def create

    @answer = Answer.new
    @answer.user_id = session[:user_id]
    @answer.puzzle_id = params[:puzzle_id]
    @answer.content = params[:content]

    respond_to do |format|
      if @answer.save
        # add a notification
        add_notification(session[:user_id], @answer.puzzle.user_id, 'add', 'answer', @answer.id)

        format.json { render json: {:status => 0, :answer_id => @answer.id, :timestamp => "<a href='#{puzzle_answer_path(@answer.puzzle, @answer)}'>#{format_time(@answer.created_at)}</a>"} , status: :created, location: @answer }
      else
        format.json { render json: @answer.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @answer = Answer.find(params[:id])

    if @answer.user_id != session[:user_id].to_s
      redirect_to root_url
    end

    @answer.content = params[:content]

    respond_to do |format|
      if @answer.save
        format.json { render json: {:status => 0} }
      else
        format.json { render json: @answer.errors, status: :unprocessable_entity }
      end
    end
  end

  def upvote
    @answer = Answer.find(params[:id])
    @user = User.find(session[:user_id])
    @action = ''

    if @user.voted_up_on? @answer
      @user.unlike @answer
      @action = 'unvote'
    else
      @user.up_votes @answer
      @action = 'vote'

      # add a notification
      add_notification(session[:user_id], @answer.user_id, 'upvote', 'answer', @answer.id)
    end

    respond_to do |format|
      format.json { render json: {:status => 0, :action => @action, :upvotes_cnt => @answer.upvotes.size, :downvotes_cnt => @answer.downvotes.size } }
    end
  end

  def downvote
    @answer = Answer.find(params[:id])
    @user = User.find(session[:user_id])
    @action = ''

    if @user.voted_down_on? @answer
      @user.undislike @answer
      @action = 'unvote'
    else
      @user.down_votes @answer
      @action = 'vote'
    end

    respond_to do |format|
      format.json { render json: {:status => 0, :action => @action, :upvotes_cnt => @answer.upvotes.size, :downvotes_cnt => @answer.downvotes.size } }
    end
  end

  def mark_as_correct
    @answer = Answer.find(params[:id])

    if (@answer.puzzle.user_id.to_i == session[:user_id])
      last_correct = @answer.puzzle.answers.where(:is_best => true)
      if (last_correct.present?)
        last_correct = last_correct.first
        last_correct.is_best = false
        last_correct.save

        # remove notification
        remove_notification(session[:user_id], @answer.user_id, 'mark_as_correct', 'answer', @answer.id)
      end

      @answer.puzzle.has_best_answer = true
      @answer.is_best = true

      respond_to do |format|
        if (@answer.save && @answer.puzzle.save)
          # add a notification
          add_notification(session[:user_id], @answer.user_id, 'mark_as_correct', 'answer', @answer.id)

          format.json { render json: {:status => 0} }
        end
      end
    end
  end

  def cancel_mark_as_correct
    @answer = Answer.find(params[:id])

    if (@answer.puzzle.user_id.to_i == session[:user_id] && @answer.is_best == true)
      @answer.puzzle.has_best_answer = false
      @answer.is_best = false

      respond_to do |format|
        if (@answer.save && @answer.puzzle.save)
          # remove notification
          remove_notification(session[:user_id], @answer.user_id, 'mark_as_correct', 'answer', @answer.id)

          format.json { render json: {:status => 0} }
        end
      end
    end
  end

end
