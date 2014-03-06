require 'spec_helper'

describe "Users" do
  
  describe "Sign Up" do
    
    describe "failure" do

      it "should not make a user and show the errors in a div" do 
        lambda do 
          visit signup_path
          fill_in "Name", with: ""
          fill_in "Email", with: ""
          fill_in "Password", with: ""
          fill_in "Confirmation", with: ""
          click_button "Sign Up"
          #expect(page).to render_template('users/new')
          expect(page).to have_css('div#error_explanation')
        end.should_not change(User, :count)
      end
    end

    describe "success" do 
      it "should make a user and show the profile page" do 
        lambda do 
          visit signup_path
          fill_in "Name", with: "Example User"
          fill_in "Email", with: "userexample@example.com"
          fill_in "Password", with: "foobar"
          fill_in "Confirmation", with: "foobar"
          click_button "Sign Up"
          expect(page).to have_css('div.flash.success', text: "Welcome")
          #expect(response).to render_template('users/show')
        end.should change(User, :count).by(1)
      end
    end
  end
end
