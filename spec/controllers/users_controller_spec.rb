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
      expect(page).to have_selector 'h1', text: @user.name
     end

     it "should have a profile image" do 
      expect(page).to have_selector 'h1>img'
     end

     it "should have the right URL" do 
      expect(page).to have_selector("td>a[href='#{user_path(@user)}']", :text=> user_path(@user))
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
  end

  describe "POST 'create'" do 

    describe "failure" do 

      before(:each) do 
        @attr = { name: "", email: "", password: "", password_confirmation: "" }
      end

      # it "should have the right title" do 
      #   post :create, user: @attr
      #   expect(page).to have_title "Sign Up"
      # end

      it "should render the 'new' page" do
        post :create, user: @attr
        expect(response).to render_template 'new'
      end

      it "should not create a user" do 
        lambda do
          post :create, user: @attr
        end.should_not change(User, :count)
      end
    end

    describe "success" do 

      before(:each) do 
        @attr = { name: "New user", email: "user@example.com", password: "foobar", password_confirmation: "foobar" }
      end

      it "should create a user" do 
        lambda do 
          post :create, user: @attr
        end.should change(User, :count).by(1)
      end

      it "should redirect to the user show page" do 
        post :create, user: @attr
        expect(response).to redirect_to user_path(assigns(:user))
      end

      it "should have a welcome message" do 
        post :create, user: @attr
        expect(flash[:success]).to match /welcome to the sample app/i
      end
    end
  end

end
