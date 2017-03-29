module ProfilesHelper
  def left_submenus
    domain = @user.path
    submenus = Array.new
    submenus << {:id => 'puzzles', :url => "/#{domain}/puzzles", :cnt => @user.puzzles.saved.count, :name => t(:puzzle)}
    submenus << {:id => 'answered', :url => "/#{domain}/answered", :cnt => @user.answers.count, :name => t(:answer)}
    submenus << {:id => 'favorites', :url => "/#{domain}/favorites", :cnt => @user.votes.up.for_type(Puzzle).size, :name => t(:favorite)}
    #submenus << {:id => 'retweets', :url => "/#{domain}/retweets", :cnt => '10', :name => t(:retweet)}
  end

  def right_submenus
    domain = @user.path
    submenus = Array.new
    submenus << {:id => 'followers', :url => "/#{domain}/followers", :cnt => @user.follower_cnt, :name => t(:follower)}
    submenus << {:id => 'follows', :url => "/#{domain}/follows", :cnt => @user.follow_cnt, :name => t(:follow)}
  end

  def upvote_count(user)
    cnt = 0

    user.answers.each do |answer|
      cnt += answer.cached_votes_up
    end

    cnt
  end

  def get_user_douban_link

    link = nil;

    if @user.from_provider && @user.provider.provider == 'douban'
      link = @user.provider.url
    end

    if @user.douban_link.present?
      link = @user.douban_link
    end

    link
  end

  def get_user_weibo_link

    link = nil;

    if @user.from_provider && @user.provider.provider == 'weibo'
      link = @user.provider.url
    end

    if @user.weibo_name.present?
      link = 'http://weibo.com/n/' + @user.weibo_name
    end

    link
  end

end
