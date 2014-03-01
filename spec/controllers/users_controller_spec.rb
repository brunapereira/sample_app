require 'spec_helper'

describe UsersController do
  render_views

    it "returns http success" do
      get 'new'
      response.should be_success
    end

    it "should have the title 'Ruby on Rails Tutorial Sample App | Contact'" do
      visit '/users/new'
      expect(page).to have_title("Sign Up")
    end

    

end
