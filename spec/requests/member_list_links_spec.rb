require 'spec_helper'

describe "MemberListLinks" do

  describe 'for ordinary users' do
    it 'should not have delete links' do
      visit signin_path
      integration_sign_in(Factory(:user))
      get '/users'
      response.should_not have_selector('a', :content => 'delete')
    end
  end

  describe 'for admin users' do
    it 'should have delete links' do
      visit signin_path
      user = Factory(:user)
      user.toggle!(:admin)
      integration_sign_in(user)
      get '/users'
      response.should have_selector('a', :content => 'delete')
    end
  end
end
