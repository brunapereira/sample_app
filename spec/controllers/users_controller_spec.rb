require 'spec_helper'

describe UsersController do
  render_views

  describe "GET 'show'" do 

    before(:each) do 
      @user = Factory(:user)
    end
  
    it "should be successful" do 
      get 'show', id: @user 
      expect(response).to be_success
    end
  end

  describe "GET 'new" do 
    
    it "returns http success" do
      visit '/users/new'
      expect(response).to be_success
    end

    it "should have the title 'Ruby on Rails Tutorial Sample App | Sign Up'" do
      visit '/users/new'
      expect(page).to have_title "Ruby on Rails Tutorial Sample App | Sign Up" 
    end

    it "test" do 
      visit '/users/new'
      expect(page).to have_selector('h1', text: "Users#new")
    end
  end
end
