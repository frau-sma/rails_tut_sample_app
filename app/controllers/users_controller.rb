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
end
