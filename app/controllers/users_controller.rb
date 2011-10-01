class UsersController < ApplicationController

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
    @user = User.find(params[:id])
    @title = 'Edit Profile'
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success] = 'Profile updated.'
      redirect_to @user
    else
      @title = 'Edit Profile'
      render 'edit'
    end
  end
end
