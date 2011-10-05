require 'spec_helper'

describe "RootPageLayout" do

  before(:each) do
    @user = Factory(:user)
    visit signin_path
    integration_sign_in(@user)
    visit root_path
  end

  it "should display a count of the user's microposts" do
    response.should have_selector('span.microposts', :content => @user.microposts.count.to_s)
  end

  it 'should update the micropost count when a post is created' do
    count = @user.microposts.count
    response.should have_selector('span.microposts', :content => count.to_s)
    fill_in :micropost_content, :with => 'foo bar'
    click_button
    response.should have_selector('span.microposts', :content => (count + 1).to_s)
  end

  it 'should pluralise the micropost count correctly' do
    count = @user.microposts.count
    response.should have_selector('span.microposts', :content => "#{count} micropost" + (count == 1 ? '' : 's'))
    fill_in :micropost_content, :with => 'foo bar'
    click_button
    response.should have_selector('span.microposts', :content => "#{count + 1} micropost" + ((count + 1) == 1 ? '' : 's'))
    fill_in :micropost_content, :with => 'baz quux'
    click_button
    response.should have_selector('span.microposts', :content => "#{count + 2} micropost" + ((count + 2) == 1 ? '' : 's'))
  end
end
