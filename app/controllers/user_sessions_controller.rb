class UserSessionsController < ApplicationController
  skip_before_filter :require_picker_user, only: [:new, :create]

  layout "login"

  def new
    @user_session = UserSession.new
  end
  
  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      flash.now[:notice] = "Successfully logged in."
      redirect_to current_user.admin? ? admin_url : root_url
    else
      flash[:error] = @user_session.errors.full_messages.to_a
      redirect_to login_url
      # render :new
    end
  end
  
  def destroy
    @user_session = UserSession.find
    @user_session.destroy
    flash[:notice] = "Successfully logged out."
    redirect_to login_url
  end
end
