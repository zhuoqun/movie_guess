class CommentsController < ApplicationController
  before_filter :require_login, :only => [:create, :update]

  def index
    answer_id = params[:answer_id]

    @data = Array.new

    Answer.find(answer_id).comments.each do |comment|
      @data.push({:comment_id => comment.id, :content => comment.content, :user_url => "/#{comment.user_id}", :user_avatar => comment.user.avatar.url, :user_id => comment.user.id, :user_name => comment.user.user_name, :timestamp => format_time(comment.updated_at)})
    end

    respond_to do |format|
      format.json { render json: @data }
    end

  end

  def create

    @comment = Comment.new
    @comment.user_id = session[:user_id]
    @comment.answer_id = params[:answer_id]
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

    @comment.content = content

    respond_to do |format|
      if @comment.save
        # add a notification
        add_notification(session[:user_id], @comment.answer.user_id, 'add', 'comment', @comment.id)

        # notification for the mention people
        if mention_ids.present?
          mention_ids.each do |id|
            add_notification(session[:user_id], id, 'mention', 'comment', @comment.id)
          end
        end

        format.json { render json: {:status => 0, :comment => {:comment_id => @comment.id, :content => @comment.content.html_safe, :user_url => "/#{@comment.user_id}", :user_avatar => @comment.user.avatar_small, :user_id => @comment.user.id, :user_name => @comment.user.user_name}}, status: :created }
      else
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
  end
end
