class ForgotPasswordsController < ApplicationController
  layout 'accounts'

  def new
  end

  def create
    user = User.find_by_email(params[:email])
    if user
      user.send_password_reset
    else
      flash.now[:alert] = t :reset_password_wrong_email
      render :new
    end
  end

  def edit
    @user = User.find_by_password_reset_token!(params[:id])
  end

  def update
    @user = User.find_by_password_reset_token!(params[:id])
    if @user.password_reset_sent_at < 2.hours.ago
      redirect_to new_forgot_password_path, :alert => 'Expired'
    elsif @user.update_attributes(params[:user])
      redirect_to login_accounts_path, :notice => (t :reset_password_success)
    else
      render :edit
    end
  end
end
