class UsersController < ApplicationController
  before_filter :authenticate, :only => [:index, :edit, :update, :destroy]
  before_filter :correct_user, :only => [:edit, :update]
  before_filter :admin_user,   :only => :destroy
  
  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(:page => params[:page])
      @title = CGI.escapeHTML(@user.name)
  end
  
  def new
    @user = User.new
    @title = "Sign Up"
  end
  
  def create
      @user = User.new(params[:user])
      if @user.save
        sign_in @user
        flash[:success] = "Welcome to the Sample App!"
        redirect_to @user
      else
        @title = "Sign up"
        render 'new'
      end
  end
  
  def index 
    @title = "All users"
    @users = User.paginate(:page => params[:page])
  end 
  
  def edit
    @title = "Edit user"
  end 
  
  def update
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated." 
      redirect_to @user
    else
      @title = "Edit user" 
      render 'edit'
    end 
  end 
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed."
    redirect_to users_path
  end 
  
  private 
  
  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_path) unless current_user?(@user)
  end 
  
  def admin_user
    redirect_to(root_path) unless current_user.admin?
  end 
end
