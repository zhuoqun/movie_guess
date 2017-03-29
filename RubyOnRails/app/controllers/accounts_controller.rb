class AccountsController < ApplicationController

  before_filter :set_page_info
  before_filter :require_login, :only => [:settings, :all_users]
  before_filter :set_section_info, :only => [:settings, :update]
  skip_before_filter :set_page_info, :only => [:create, :update]

  def login
    @referer = request.env["HTTP_REFERER"]
    if session[:user_id].present?
      redirect_to root_path
    end
  end

  def signup
    if session[:user_id].present?
      redirect_to root_path
    end

    @user = User.new
  end

  def create
    @user = User.new(params[:user])

    if params[:user][:user_name].present?
      @user.name_filter = params[:user][:user_name].downcase + PinYin.of_string(params[:user][:user_name]).join.downcase + PinYin.abbr(params[:user][:user_name])
    end

    respond_to do |format|
      if @user.save
        # TODO: confirm the email
        format.html { redirect_to login_accounts_path, notice: (t :signup_success) }
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render action: "signup" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def settings
    @user = current_user

    render @page_id
  end

  def update
    @user = User.find(params[:id])

    if @user.id != session[:user_id]
      redirect_to root_url
    end

    if @section == 'avatar'
      if params[:user].nil?
        @user.errors.add(:avatar, :empty)
        render @page_id
      elsif params[:user][:crop_w].blank?
        if @user.update_attributes(params[:user])
          @wait_crop = true
        end
        render @page_id
      else
        @wait_crop = nil

        respond_to do |format|
          if @user.update_attributes(params[:user])
            format.html { redirect_to settings_accounts_path + '/' + @section, notice: (t :update_success)}
            format.json { head :no_content }
          else
            format.html { render @page_id }
            format.json { render json: @user.errors, status: :unprocessable_entity }
          end
        end
      end
    elsif @section == 'complete_info'
      respond_to do |format|
        if @user.update_attributes(params[:user])
          format.html { redirect_to root_url, notice: (t :update_success)}
          format.json { head :no_content }
        else
          format.html { render 'complete_info' }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
    else
      if params[:user][:user_name].present?
        @user.name_filter = params[:user][:user_name].downcase + PinYin.of_string(params[:user][:user_name]).join.downcase + PinYin.abbr(params[:user][:user_name])
      end
      respond_to do |format|
        if @user.update_attributes(params[:user])
          format.html { redirect_to settings_accounts_path + '/' + @section, notice: (t :update_success)}
          format.json { head :no_content }
        else
          format.html { render @page_id }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
    end

  end

  def complete_info
    if current_user.nil? || current_user.from_provider == false || current_user.email.present?
      redirect_to root_url
    end

    @user = current_user
  end

  def all_users
    if params[:query].present?
      query = params[:query].downcase
      users = User.where("name_filter like '%#{query}%'")
    else
      users = current_user.follows + current_user.followers
    end

    @data = []

    users.each do |u|
      @data.push({id:u.id, name:u.user_name, avatar:u.avatar_small, filter:u.name_filter})
    end

    respond_to do |format|
      format.json { render json: @data }
    end
  end

  private

  def set_page_info
    @page_id = action_name
  end

  def set_section_info

    if current_user.from_provider && current_user.email.blank? && params[:id].blank?
      redirect_to complete_info_accounts_path
    end

    @section = params[:section].nil? ? 'profile' : params[:section]
    @page_id = 'setting_' + @section
    @page_title = t @page_id.to_sym
  end
end
