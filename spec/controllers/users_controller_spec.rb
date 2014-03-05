require 'spec_helper'

describe UsersController do
  render_views

   describe "GET 'show'" do 

     before(:each) do 
       @user = Factory(:user)
       visit user_path(@user) 
     end
  
     it "should be successful" do 
       expect(response).to be_success
     end

     it "should have the right title" do 
       expect(page).to have_title @user.name
     end

     it "should have the user's name" do 
       expect(page).to have_selector('h1', text: @user.name)
     end

     it "should have a profile image" do 
       expect(page).to have_selector('h1>img')
     end
   end

  describe "GET 'new" do 
    
    it "returns http success" do
      visit '/users/new'
      expect(response).to be_success
    end

    it "should have the title the right title" do
      visit '/users/new'
      expect(page).to have_title "Sign Up" 
    end

    it "test" do 
      visit '/users/new'
      expect(page).to have_selector('h1', text: "Users#new")
    end
  end
end
