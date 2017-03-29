module ApplicationHelper
  def global_nav_items
    [{:id => 'index', :url => '/', :name => t(:page_index)}, {:id => 'screenshot', :url => '/screenshot/', :name => t(:page_screenshot)}, {:id => 'lines', :url => '/lines/', :name => t(:page_lines)}, {:id => 'fast', :url => '/fast/', :name => t(:page_fast)}]
  end

  # Generate title for every page
  def page_title
    if @page_title.nil?
      if @page_id.nil? || @page_id == 'index'
        t :site_name
      else
        t("page_#{@page_id}".to_sym) + ' | ' + t(:site_name)
      end
    else
      if @page_id.present? && @page_id == 'show'
        @page_title
      else
        @page_title  = @page_title + ' | ' + t(:site_name)
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


  def user_follows_page(domain)
    "/#{domain}/follows"
  end

  def user_followers_page(domain)
    "/#{domain}/followers"
  end

  def user_answered_page(domain)
    "/#{domain}/answered"
  end

  def user_puzzles_page(domain)
    "/#{domain}/puzzles"
  end

end
