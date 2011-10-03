class UsersController < ApplicationController
  before_filter :authenticate, :only => [:index, :edit, :update]
  before_filter :correct_user, :only => [:edit, :update]

  def index
    @title = 'Members'
    @users = User.paginate(:page => params[:page])
  end

  def show
    @user = User.find(params[:id])
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

  private

  def authenticate
    deny_access unless signed_in?
  end

  def correct_user
    @user = User.find(params[:id])
    unless current_user?(@user)
      flash[:notice] = 'You may only edit your own profile.'
      redirect_to(root_path)
    end
  end
end
