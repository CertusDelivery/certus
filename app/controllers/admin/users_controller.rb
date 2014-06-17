module Admin
  class UsersController < AdminController
    def index
      @users = User.all
    end

    def new
      @user = User.new
    end
    
    def create
      @user = User.new(user_params)
      if @user.save
        flash[:notice] = "Registration successful."
        redirect_to admin_users_url
      else
        render :action => 'new'
      end
    end
    
    def edit
      @user = User.find(params[:id])
    end
    
    def update
      @user = User.find(params[:id])
      if @user.update_attributes(user_params)
        flash[:notice] = "Successfully updated profile."
        redirect_to admin_users_url
      else
        render :action => 'edit'
      end
    end

    private

    def user_params
      params.require(:user).permit(:login, :email, :password, :password_confirmation, :first_name, :last_name, :role, :enabled)
    end
  end
end
