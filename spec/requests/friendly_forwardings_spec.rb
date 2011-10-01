require 'spec_helper'

describe "FriendlyForwardings" do

  it 'should forward to the requested page after sign-in' do
    user = Factory(:user)
    visit edit_user_path(user)
    # the test automagically follows the redirect to the sign-in page
    integration_sign_in(user)
    # the test follows the redirect back to users/edit
    response.should render_template('users/edit')
  end
end
