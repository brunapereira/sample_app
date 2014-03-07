require 'spec_helper'

describe SessionsController do
  
  render_views

  describe "GET 'new'" do
    it "returns http success" do
      get :new
      expect(response).to be_success
    end

    it "should have the title the right title" do
      visit '/signin'
      expect(page).to have_title "Sign in"
    end
  end

end