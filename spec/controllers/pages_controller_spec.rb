require 'spec_helper'

describe PagesController do
  render_views

  before(:each) do
    @base_title = 'Sample App'
  end

  # tests for Home page

  describe "GET 'home'" do

    describe 'when not signed in' do

      it 'should be successful' do
        get 'home'
        response.should be_success
      end

      it 'should have the right title' do
        get 'home'
        response.should have_selector('title', :content => @base_title + ' :: Home')
      end
    end

    describe 'when signed in' do

      before(:each) do
        @user = test_sign_in(Factory(:user))
        other_user = Factory(:user, :email => Factory.next(:email))
        other_user.follow!(@user)
      end

      it 'should have the right follower/following counts' do
        get :home
        response.should have_selector('a', :href => following_user_path(@user), :content => '0 following')
        response.should have_selector('a', :href => followers_user_path(@user), :content => '1 follower')
      end
    end
  end

  # tests for Contact page

  describe "GET 'contact'" do
    it "should be successful" do
      get 'contact'
      response.should be_success
    end

    it 'should have the right title' do
      get 'contact'
      response.should have_selector('title', :content => @base_title + ' :: Contact')
    end
  end

  # tests for About page

  describe "GET 'about'" do
    it "should be successful" do
      get 'about'
      response.should be_success
    end

    it 'should have the right title' do
      get 'about'
      response.should have_selector('title', :content => @base_title + ' :: About')
    end
  end

  # tests for Help page

  describe "GET 'help'" do
    it 'should be successful' do
      get 'help'
      response.should be_success
    end

    it 'should have the right title' do
      get 'help'
      response.should have_selector('title', :content => 'Sample App :: Help')
    end
  end
end
