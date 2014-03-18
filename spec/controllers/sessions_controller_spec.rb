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

  describe "POST 'create'" do 
    
    describe "failure" do 
        
      before(:each) do 
        @attr = { email: "", password: "" }
      end

      it "should re-render the 'new' page" do 
        post :create, session: @attr
        expect(response).to render_template('new')
      end

      # it "should have the right title" do 
      #   post :create, session: @attr
      #   expect(response).to have_selector(:title, text: "Sign in")
      # end

      it "should have an error message" do 
        post :create, session: @attr
        expect(flash.now[:error]).to match /invalid/i
      end
    end

    describe "success" do 

      before(:each) do 
        @user = Factory(:user)
        @attr = { email: @user.email, password: @user.password }
      end

      it "should sign the user in" do
        post :create, session: @attr 
        expect(controller.current_user).to eq @user
        expect(controller).to be_signed_in
      end

      it "should redirect to the user show page" do 
        post :create, session: @attr
        expect(response).to redirect_to(user_path(@user))
      end
    end
  end

end