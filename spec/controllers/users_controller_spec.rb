require 'spec_helper'

describe UsersController do
  render_views

  describe "GET 'index'" do
    
    context "for non-signed-in users" do 
      
      it "should deny access" do 
        get :index
        expect(response).to redirect_to signin_path
      end
    end

    context "for signed-in-users" do 

      before :each do 
        @user = test_sign_in(Factory(:user))
        Factory(:user, email: "bruna@bruna.net")
        Factory(:user, email: "bruna@bruna.com")

        30.times do 
          Factory(:user, email: Factory.next(:email))
        end
      end

      it "should be successful" do 
        get :index
        expect(response).to be_success
      end

      it "should have the right title" do 
        get :index
        expect(response).to have_selector('title', content: "All users")
      end

      it "should have an element for each user" do 
        get :index
        User.paginate(page: 1).each do |user|
          expect(response).to have_selector("li", content: user.name)
        end
      end

      it "should paginate users" do 
        get :index
        expect(response).to have_selector('div.pagination')
        expect(response).to have_selector('span.disabled', content: "Previous")
        expect(response).to have_selector('a', href: "/users?page=2", content: "2")
        expect(response).to have_selector('a', href: '/users?page=2', content: "Next")
      end
    

      it "should have a delete link for admins" do 
        @user.toggle!(:admin)
        other_user = User.all.second
        get :index
        expect(response).to have_selector('a', href: user_path(other_user), content: "delete")
      end

      it "should not have a delete link for admins" do 
        other_user = User.all.second
        get :index
        expect(response).to_not have_selector('a', href: user_path(other_user), content: "delete")
      end
    end
  end 

  describe "GET 'show'" do 

    before(:each) do 
      @user = Factory(:user)
    end

    it "should be successful" do 
      get :show, id: @user
      expect(response).to be_success
    end

    it "should find the right user" do
      get :show, id: @user
      expect(assigns(:user)).to eql @user
    end

    it "should have the right title" do 
      get :show, id: @user
      expect(response).to have_selector('title', content: @user.name)
    end

    it "should have the user's name" do 
      get :show, id: @user
      expect(response).to have_selector('h1', content: @user.name)
    end

    it "should have a profile image" do 
      get :show, id: @user
      expect(response).to have_selector('h1>img', class: "gravatar")
    end

    it "should have the right URL" do 
      get :show, id: @user
      expect(response).to have_selector("td>a", href: user_path(@user), content: user_path(@user))
    end

    it "should show the user's microposts" do 
      mp1 = Factory :micropost, user: @user, content: "Foobar"
      mp2 = Factory :micropost, user: @user, content: "Bruna"
      get :show, id: @user
      expect(response).to have_selector('span.content', content: mp1.content)
      expect(response).to have_selector('span.content', content: mp2.content)
    end

    it "should paginate microposts" do
      35.times { Factory(:micropost, user: @user, content: "foo") }
      get :show, id: @user
      expect(response).to have_selector('div.pagination')
    end

    it "should display the micropost count" do 
      10.times { Factory(:micropost, user: @user, content: "foo") }
      get :show, id: @user
      expect(response).to have_selector 'td.sidebar', content: @user.microposts.count.to_s 
    end
  end

  describe "GET 'new" do 
    
    it "returns http success" do
      get :new
      expect(response).to be_success
    end

    it "should have the title the right title" do
      get :new
      expect(response).to have_selector("title", content: "Sign Up")
    end
  end

  describe "POST 'create'" do 

    describe "failure" do 

      before(:each) do 
        @attr = { name: "", email: "", password: "", password_confirmation: "" }
      end

      it "should have the right title" do 
        post :create, user: @attr
        expect(response).to have_selector("title", content: "Sign Up")
      end

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

      it "should sign the user in" do 
        post :create, user: @attr
        expect(controller).to be_signed_in
      end
    end
  end

  describe "GET 'edit'" do 

    before(:each) do 
      @user = Factory(:user) 
      test_sign_in @user
    end

    it "should be successfull" do 
      get :edit, id: @user
      expect(response).to be_success
    end

    it "should have the right title" do 
      get :edit, id: @user
      expect(response).to have_selector("title", content: "Edit user") 
    end

    it "should have a link to change the Gravatar" do 
      get :edit, id: @user
      expect(response).to have_selector("a", href: 'http://gravatar.com/emails', content: "Change")
    end
  end

  describe "PUT 'update'" do 

    before :each do 
      @user = Factory :user
      test_sign_in @user
    end 

    describe "failure" do

      before(:each) do 
        @attr = { name: "", email: "", password: "", password_confirmation: "" }
      end 
      
      it "should render the 'edit' page" do 
        put :update, id: @user, user: @attr
        expect(response).to render_template "edit"
      end

      it "should have the right title" do 
        put :update, id: @user, user: @attr
        expect(response).to have_selector("title", content: "Edit user")
      end
    end

    describe "success" do 

      before(:each) do 
        @attr = { name: "Bruna", email: "example@example.com", password: "foobar", password_confirmation: "foobar" }
      end 

      it "should change the users attributes" do 
        put :update, id: @user, user: @attr
        user = assigns(:user)
        @user.reload
        expect(@user.name).to eq user.name
        expect(@user.email).to eq user.email
        expect(@user.encrypted_password).to eq user.encrypted_password
      end

      it "should have a flash message" do 
        put :update, id: @user, user: @attr
        expect(flash[:success]).to match /updated/i
      end
    end
  end

  describe "authentication of edit/update actions" do 

    before :each do 
      @user = Factory :user
    end

    context "for non-signed-in users" do 

      it "should deny access to 'edit'" do 
        get :edit, id: @user
        expect(response).to redirect_to signin_path
        expect(flash[:notice]).to match /sign in/i
      end

      it "should deny access to 'update'" do 
        put :update, id: @user, user: {}
        expect(response).to redirect_to signin_path 
      end
    end

    context "for signed-in-users" do 

      before :each do 
        wrong_user = Factory(:user, email: "user@example.net")
        test_sign_in(wrong_user)
      end
      
      it "should require matching users for 'edit'" do 
        get :edit, id: @user
        expect(response).to redirect_to(root_path)
      end

      it "should require matching users for 'update'" do 
        get :edit, id: @user, user: {}
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "DELETE 'destroy'" do 

    before(:each) do 
      @user = Factory(:user)
    end

    context "as a non-signed-in user" do 
      it "should deny access" do 
        delete :destroy, id: @user
        expect(response).to redirect_to signin_path
      end
    end

    context "as non-admin user" do 
      it "should protect the action" do 
        test_sign_in(@user)
        delete :destroy, id: @user
        expect(response).to redirect_to root_path
      end
    end

    context "as an admin user" do 

      before(:each) do
        @admin = Factory(:user, email: "admin@example.com", admin: true)
        test_sign_in(@admin)
      end 

      it "should destroy the user" do 
        lambda do
          delete :destroy, id: @user
        end.should change(User, :count).by(-1)
      end

      it "should redirect to the users page" do 
        delete :destroy, id: @user
        expect(flash[:success]).to match /destroyed/i
        expect(response).to redirect_to users_path
      end

      it "should not be able to destroy itself" do 
        lambda do 
          delete :destroy, id: @admin
        end.should_not change(User, :count)
      end
    end
  end

end
