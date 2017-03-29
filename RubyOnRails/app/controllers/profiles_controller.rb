class ProfilesController < ApplicationController

  before_filter :set_page_info
  before_filter :require_login, :only => [:follow, :unfollow, :notifications]
  skip_before_filter :set_page_info, :only => [:follow, :unfollow, :notifications, :unread_notifications]

  def show
    @puzzles = @user.puzzles.saved.limit(10).offset(params[:start]).order('created_at desc')
    @ajax_request_url = "/#{@user.id}/puzzles.json"

    @data = produce_puzzles @puzzles

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @data }
    end
  end

  def puzzles
    @puzzles = @user.puzzles.saved.limit(10).offset(params[:start]).order('created_at desc')
    @ajax_request_url = "/#{@user.id}/puzzles.json"

    @data = produce_puzzles @puzzles

    respond_to do |format|
      format.html {render 'show'}
      format.json { render json: @data }
    end
  end

  def answered
    @answers = @user.answers.limit(10).offset(params[:start]).order('created_at desc').uniq
    @puzzles = Array.new
    @answers.each do |answer|
      @puzzles.push Puzzle.find(answer.puzzle_id)
    end
    @ajax_request_url = "/#{@user.id}/answered.json"

    @data = produce_puzzles @puzzles

    respond_to do |format|
      format.html {render 'show'}
      format.json { render json: @data }
    end
  end

  def favorites
    @puzzles = @user.votes.up.for_type(Puzzle).limit(10).offset(params[:start]).order('created_at desc').votables
    @ajax_request_url = "/#{@user.id}/favorites.json"

    @data = produce_puzzles @puzzles

    respond_to do |format|
      format.html {render 'show'}
      format.json { render json: @data }
    end
  end

  def retweets
    render 'show'
  end

  def follows
    @users = @user.follows
  end

  def followers
    @users = @user.followers
  end

  def follow
    contact_id = params[:id]

    if UserRelation.where(:user_id => session[:user_id], :contact_id => contact_id, :relation_code_id => 1).blank?
      follow = UserRelation.new
      follow.user_id = session[:user_id]
      follow.contact_id = contact_id
      follow.relation_code_id = 1
    else
      follow = true
    end

    respond_to do |format|
      if follow == true 
        format.json { render json: {:status => 0} }
      elsif follow.save
        # add a notification
        add_notification(session[:user_id], contact_id, 'follow', 'user', contact_id)

        format.json { render json: {:status => 0} }
      else
        format.json { render json: follow.errors, status: :unprocessable_entity }
      end
    end
  end

  def unfollow
    contact_id = params[:id]

    follow = UserRelation.where(:user_id => session[:user_id], :contact_id => contact_id, :relation_code_id => 1).first

    respond_to do |format|
      if follow.nil? || follow.destroy
        # remove notification
        remove_notification(session[:user_id], contact_id, 'follow', 'user', contact_id)

        format.json { render json: {:status => 0} }
      else
        format.json { render json: follow.errors, status: :unprocessable_entity }
      end
    end
  end

  def notifications
    @notifications = Notification.all(session[:user_id], 10, params[:start])

    @data = Array.new
    @notifications.each do |item|
      unread = item.is_viewed ? '' : 'unread'
      avatar = item.user.avatar_small
      user_name = item.user.user_name
      user_path = item.user.path
      path = ''

      if (item.target_type == 'answer')
        answer = Answer.find(item.target_id)
        path = puzzle_answer_path(answer.puzzle, answer)
      elsif (item.target_type == 'comment')
        comment = Comment.find(item.target_id)
        path = puzzle_answer_path(comment.answer.puzzle, comment.answer)
      elsif (item.target_type == 'discussion')
        discussion = Discussion.find(item.target_id)
        path = puzzle_path(discussion.puzzle_id)
      end

      timestamp = format_time(item.created_at)

      @data.push({:unread => unread, :avatar => avatar, :user_name => user_name, :user_path => user_path, :path => path, :timestamp => timestamp, :action => item.action, :target_type => item.target_type})
    end

    respond_to do |format|
      format.html
      format.json { render json: @data}
    end
  end

  def unread_notifications

    respond_to do |format|
      if session[:user_id].nil?
        format.json { render json: {:status => -2} }
      else
        @count = Notification.where(:is_viewed => false, :contact_id => session[:user_id]).count
        format.json { render json: @count}
      end
    end

  end

  private

  def set_page_info
    @page_id = action_name

    user_id = params[:category] || params[:id]
    if user_id.to_i != 0
      @user = User.find(user_id)
    else
      @user = User.find_by_domain(user_id)
    end

    if @page_id == 'show'
      @page_title = @user.user_name
    else
      pages = {:puzzles => 'puzzle', :answered => 'answer', :favorites => 'favorite', :retweets => 'retweet', :follows => 'follow', :followers => 'follower'}
      suffix = (t :s) + (t pages[@page_id.to_sym].to_sym)
      @page_title = @user.user_name + suffix
    end
  end
end
