require 'spec_helper'

describe MicropostsController do
  render_views

  describe "access controll" do 
    
    it "should deny access to 'create'" do 
      post :create
      expect(response).to redirect_to signin_path
    end

    it "should deny acces to 'destroy'" do 
      delete :destroy, id: 1
      expect(response).to redirect_to signin_path
    end
  end

  describe "POST 'create'" do

    before :each do 
      @user = test_sign_in(Factory :user)
    end

    context "failure" do 

      before :each do 
        @attr = { content: "" }
      end

      it "should not create a micropost" do 
        lambda do 
          post :create, micropost: @attr 
        end.should_not change(Micropost, :count)
      end

      it "should re-render the home page" do 
        post :create, micropost: @attr
        expect(response).to render_template('pages/home')
      end
    end

    context "success" do 

      before :each do 
        @attr = { content: "lorem ipsum dolor sit amet" }
      end

      it "should create a micropost" do 
        lambda do
          post :create, micropost: @attr
        end.should change(Micropost, :count).by(1)
      end

      it "should redirect_to root path" do
        post :create, micropost: @attr
        expect(response).to redirect_to root_path
      end

      it "should have a flash success message" do 
        post :create, micropost: @attr
        expect(flash[:success]).to match /micropost created/i
      end
    end
  end

  describe "DELETE 'destroy'" do 

    context "for an unauthorized user" do 
      
      before :each do 
        @user = Factory(:user)
        wrong_user = Factory(:user, email: Factory.next(:email))
        @micropost = Factory(:micropost, user: @user)
        test_sign_in wrong_user
      end

      it "should deny access" do
        delete :destroy, id: @micropost
        expect(response).to redirect_to root_path
      end
    end

    context "for an authorized user" do

      before :each do 
        @user = test_sign_in(Factory(:user))
        @micropost = Factory(:micropost, user: @user)
      end

      it "should destroy the micropost" do
        lambda do 
          delete :destroy, id: @micropost
          expect(flash[:success]).to match /deleted/i
          expect(response).to redirect_to root_path
        end.should change(Micropost, :count).by(-1)
      end
    end
  end
end