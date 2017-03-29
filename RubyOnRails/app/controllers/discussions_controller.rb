class DiscussionsController < ApplicationController
  before_filter :require_login, :only => [:create, :like]

  def index
    puzzle_id = params[:puzzle_id]

    @discussions = Puzzle.find(puzzle_id).discussions.order('cached_votes_up DESC, created_at DESC').limit(10).offset(params[:start])
    @data = Array.new

    @discussions.each do |discussion|
      if session[:user_id].present?
        voted_up = current_user.voted_up_on?(discussion) ? 'voted' : false
      else
        voted_up = false
      end

      @data.push({:discussion_id => discussion.id, :content => discussion.content.html_safe, :user_url => "/#{discussion.user_id}", :user_avatar => discussion.user.avatar_small, :user_id => discussion.user.id, :user_name => discussion.user.user_name, :voted_up => voted_up, :upvotes_cnt => discussion.upvotes.size, :discussion_url => puzzle_discussion_path(discussion.puzzle, discussion), :timestamp => format_time(discussion.created_at)})
    end

    respond_to do |format|
      format.json { render json: @data }
    end

  end

  def create

    @discussion = Discussion.new
    @discussion.user_id = session[:user_id]
    @discussion.puzzle_id = params[:puzzle_id]

    content = CGI::escapeHTML(params[:content])

    mention_ids = []

    if params[:mentions].present?
      params[:mentions].each do |mention|
        id = mention[1][:id]

        next if mention_ids.include?(id)

        name = mention[1][:name]

        content.gsub!(/@#{name}/, "<a href='http://caidianying.com/#{id}'>@#{name}</a>");
        mention_ids.push(id)
      end
    end

    @discussion.content = content

    respond_to do |format|
      if @discussion.save

        # notification for the mention people
        if mention_ids.present?
          mention_ids.each do |id|
            add_notification(session[:user_id], id, 'mention', 'discussion', @discussion.id)
          end
        end

        add_notification(session[:user_id], @discussion.puzzle.user_id, 'add', 'discussion', @discussion.id)

        format.json { render json: {:status => 0, :discussion => {:discussion_id => @discussion.id, :content => @discussion.content.html_safe, :user_url => "/#{@discussion.user_id}", :user_avatar => @discussion.user.avatar_small, :user_id => @discussion.user.id, :user_name => @discussion.user.user_name, :discussion_url => puzzle_discussion_path(@discussion.puzzle, @discussion), :timestamp => format_time(@discussion.created_at)}}, status: :created }
      else
        format.json { render json: @discussion.errors, status: :unprocessable_entity }
      end
    end
  end

  def upvote
    @discussion = Discussion.find(params[:id])
    @user = User.find(session[:user_id])
    @action = ''

    if @user.voted_up_on? @discussion
      @user.unlike @discussion
      @action = 'unvote'
    else
      @user.up_votes @discussion
      @action = 'vote'

      # add a notification
      add_notification(session[:user_id], @discussion.user_id, 'upvote', 'discussion', @discussion.id)
    end

    respond_to do |format|
      format.json { render json: {:status => 0, :action => @action, :upvotes_cnt => @discussion.upvotes.size } }
    end
  end

end
