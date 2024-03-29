class MicropostsController < ApplicationController
  before_filter :authenticate
  before_filter :authorised_user, :only => :destroy

  def index
    @user = User.find_by_id(params[:user_id])
    @microposts = @user.microposts.paginate(:page => params[:page], :per_page => 20)
  end

  def create
    @micropost = current_user.microposts.build(params[:micropost])
    if @micropost.save
      flash[:success] = 'Your message has been posted!'
      redirect_to root_path
    else
      @feed_items = []
      render 'pages/home'
    end
  end

  def destroy
    @micropost.destroy
    redirect_back_or root_path
  end

  private

  def authorised_user
    @micropost = current_user.microposts.find_by_id(params[:id])
    redirect_to root_path if @micropost.nil?
  end
end
