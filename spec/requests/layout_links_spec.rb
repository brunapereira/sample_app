require 'spec_helper'

describe "LayoutLinks" do

  it "should have the content 'Home'" do
    get '/'
    expect(response).to have_selector('title', content: "Home")
  end

  it "should have the content 'Contact'" do
    get '/contact'
    expect(response).to have_selector('title', content: "Contact")
  end

  it "should have the content 'About'" do
    get '/about'
    expect(response).to have_selector('title', content: "About")
  end

  it "should have the content 'Help'" do
    get '/help'
    expect(response).to have_selector('title', content: "Help")
  end    

  it "should have a sign up page at 'Sign Up'" do 
    get '/signup'
    expect(response).to have_selector('title', content: "Sign Up")
  end  

  it 'should have a sign up page at /user/new' do 
    get '/signin'
    expect(response).to have_selector('title', content: "Sign in")
  end  

  it 'should have the right links on the layout' do 
    visit root_path
    expect(page).to have_selector("h1", content: "Sample App")
    click_link "About"
    expect(page).to have_selector("h1", content: "About")
    click_link "Contact"
    expect(page).to have_selector("h1", content: "Contact")
    click_link "Home"
    expect(page).to have_selector("h1", content: "Sample App")
  end

  describe "when not signed in" do 
    it "should have a signin link" do
      visit root_path
      expect(page).to have_selector("a", href: signin_path, content: "Sign in")
    end
  end

  describe "when signed in" do 

    before(:each) do 
      @user = Factory(:user)
      visit signin_path
      fill_in :session_email, with: @user.email
      fill_in :session_password, with: @user.password
      click_button "Sign in"
    end

    it "should have a signout link" do 
      visit root_path
      expect(page).to have_selector("a", href: signout_path, content: "Sign out") 
    end

    it "should have a profile link" do
      visit root_path
      expect(page).to have_selector("a", href: user_path(@user), content: "Profile")
    end

    it "should have a settings link" do 
      visit root_path
      expect(page).to have_selector("a", href: edit_user_path(@user), content: "Settings")
    end

    it "should have a users link" do 
      visit root_path
      expect(page).to have_selector("a", href: users_path, content: "Users")
    end
  end
end
