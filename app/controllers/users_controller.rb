class UsersController < ApplicationController
  before_filter :authenticate,  :except => [:show, :new, :create]
  before_filter :correct_user,  :only => [:edit, :update]
  before_filter :admin_user,    :only => :destroy
  before_filter :not_logged_in, :only => [:new, :create]

  def index
    @title = 'Members'
    @users = User.paginate(:page => params[:page])
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(:page => params[:page], :per_page => 10)
    @title = "User Profile: #{@user.name}"
  end

  def new
    @user = User.new
    @title = 'Sign Up'
  end

  def create
    @user = User.new(params[:user])

    if @user.save
      sign_in @user
      flash[:success] = 'Welcome to the Sample App!'
      redirect_to @user
    else
      @user.password = nil
      @user.password_confirmation = nil
      @title = 'Sign Up'
      render 'new'
    end
  end

  def edit
    @title = 'Edit Profile'
  end

  def update
    if @user.update_attributes(params[:user])
      flash[:success] = 'Profile updated.'
      redirect_to @user
    else
      @title = 'Edit Profile'
      render 'edit'
    end
  end

  def destroy
    user = User.find(params[:id])
    if user == current_user
      flash[:error] = 'You may not delete yourself.'
      redirect_to users_path
    else
      user.destroy
      flash[:success] = 'User deleted.'
      redirect_to users_path
    end
  end

  def following
    show_follow(:following)
  end

  def followers
    show_follow(:followers)
  end

  private

  def correct_user
    @user = User.find(params[:id])
    unless current_user?(@user)
      flash[:notice] = 'You may only edit your own profile.'
      redirect_to(root_path)
    end
  end

  def admin_user
    redirect_to(root_path) unless current_user.admin?
  end

  def not_logged_in
    redirect_to(root_path) if signed_in?
  end

  def show_follow(action)
    @title = action.to_s.capitalize
    @user = User.find(params[:id])
    @users = @user.send(action).paginate(:page => params[:page], :per_page => 20)
    render 'show_follow'
  end
end
