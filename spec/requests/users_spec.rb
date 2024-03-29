require 'spec_helper'

describe 'Users' do

  describe 'signup' do

    describe 'failure' do

      it 'should not make a new user' do
        lambda do
          visit signup_path
          fill_in 'Name',             :with => ''
          fill_in 'Email',            :with => ''
          fill_in 'Password',         :with => ''
          fill_in 'Confirm Password', :with => ''
          click_button
          response.should render_template('users/new')
          response.should have_selector('div#error_explanation')
        end.should_not change(User, :count)
      end
    end

    describe 'success' do

      it 'should make a new user' do
        lambda do
          visit signup_path
          fill_in 'Name',             :with => 'Example User'
          fill_in 'Email',            :with => 'user@example.org'
          fill_in 'Password',         :with => 'foobar'
          fill_in 'Confirm Password', :with => 'foobar'
          click_button
          response.should render_template('users/show')
          response.should have_selector('div.flash.success', :content => 'Welcome')
        end.should change(User, :count).by(1)
      end
    end
  end

  describe 'sign in/out' do

    describe 'failure' do
      it 'should not sign a user in' do
        user = User.new(:email => '', :password => '')
        visit signin_path
        integration_sign_in(user)
        response.should have_selector('div.flash.error', :content => 'Invalid')
      end
    end

    describe 'success' do
      it 'should sign a user in and out' do
        user = Factory(:user)
        visit signin_path
        integration_sign_in(user)
        controller.should be_signed_in
        click_link 'Sign Out'
        controller.should_not be_signed_in
      end
    end
  end
end
