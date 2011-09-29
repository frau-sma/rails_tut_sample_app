class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
    @title = "User Profile: #{@user.name}"
  end

  def new
    @title = 'Sign Up'
  end
end
