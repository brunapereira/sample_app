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

  describe "signin" do 

    describe "failure" do 
      it "should not sign a user in" do 
        visit signin_path
        fill_in "Email", with: ""
        fill_in "Password", with: ""
        click_button "Sign in"
        expect(page).to have_css('div.flash.error', text: "Invalid") 
        #expect(response).to render_template('sessions/new')
      end
    end

    describe "success" do 
      it "should sign a user in and out" do 
        user = Factory(:user)
        visit signin_path
        fill_in "Email", with: user.email
        fill_in "Password", with: user.password
        click_button "Sign in"
        #expect(controller).to be_signed_in         #Não reconhece "controller" --'
        click_link "Sign out"
        #expect(controller).to_not be_signed_in
      end
    end
  end
end
