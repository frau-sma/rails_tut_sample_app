require 'spec_helper'

describe "Microposts" do

  before(:each) do
    user = Factory(:user)
    visit signin_path
    integration_sign_in(user)
  end

  describe 'creation' do

    describe 'failure' do

      it 'should not create a new micropost' do
        lambda do
          visit root_path
          fill_in :micropost_content, :with => ''
          click_button
          response.should render_template('pages/home')
          response.should have_selector('div#error_explanation')
        end.should_not change(Micropost, :count)
      end
    end

    describe 'success' do

      it 'should create a new micropost' do
        content = 'Lorem ipsum dolor sit amet'
        lambda do
          visit root_path
          fill_in :micropost_content, :with => content
          click_button
          response.should have_selector('p.content', :content => content)
        end.should change(Micropost, :count).by(1)
      end
    end
  end
end
