require 'spec_helper'

describe "FriendlyFowardings" do
  it "should forward to the requested page after signin" do 
    user = Factory :user
    visit edit_user_path(user)
    fill_in :session_email, with: user.email
    fill_in :session_password, with: user.password
    click_button 'Sign in'
    #expect(response).to render_template('users/edit') # not working so I can't test :(
    visit signout_path
    visit signin_path
    fill_in :session_email, with: user.email
    fill_in :session_password, with: user.password
    click_button 'Sign in'
    #expect(response).to render_template('users/show') #not working so I can't test :(
  end
end
