class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  #include InheritedResources::DSL
  # inherit_resources
  protect_from_forgery with: :exception

  helper_method :current_user

  private

  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.record
  end

  def deny_access
    store_location
    if request.xhr?
      render :nothing => true, :status => :unauthorized
    else
      redirect_to login_url
    end
    false
  end

  def require_user
    unless current_user
      if current_user_session && current_user_session.stale?
        flash[:notice] = "Your session has been logged out automatically"
      else
        flash[:error] = "You must be logged in to access this page"
      end

      deny_access
    else
      unless current_user.enabled?
        current_user_session.destroy if current_user_session
        @current_user = nil

        flash[:error] = t(:account_disabled, :scope => [:controllers, :user_sessions])
        deny_access
      end
    end
  end

  def require_admin_user
    require_user
    return unless current_user
    unless current_user.admin?
      flash[:error] = "You must be logged in as an administrator to access this page"
      deny_access
    end
  end

  def store_location
    session[:return_to] = request.fullpath
  end
end
