require 'spec_helper'

describe "LayoutLinks" do

  it "should have the content 'Home'" do
    get '/'
    expect(response).to be_success
  end

  it "should have the content 'Contact'" do
    get '/contact'
    expect(response).to be_success
  end

  it "should have the content 'About'" do
    get '/about'
    expect(response).to be_success
  end

  it "should have the content 'Help'" do
    get '/help'
    expect(response).to be_success
  end    

  it 'should have a sign up page at /user/new' do 
    get '/signup'
    expect(response).to be_success
  end  

  it 'should have a sign up page at /user/new' do 
    get '/signin'
    expect(response).to be_success
  end  

  it 'should have the right links on the layout' do 
    visit root_path
    expect(page).to have_selector("h1", text: "Home")
    click_link "About"
    expect(page).to have_selector("h1", text: "About")
    click_link "Contact"
    expect(page).to have_selector("h1", text: "Contact")
    click_link "Home"
    expect(page).to have_selector("h1", text: "Home")
  end

  describe "when not signed in" do 
    it "should have a signin link" do
      visit root_path
      expect(page).to have_selector("a[href='#{signin_path}']", text: "Sign in")
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
      expect(page).to have_selector("a[href='#{signout_path}']", text: "Sign out") 
    end

    it "should have a profile link" do
      visit root_path
      expect(page).to have_selector("a[href='#{user_path(@user)}']", :text=> "Profile")
    end

    it "should have a settings link" do 
      visit root_path
      expect(page).to have_selector("a[href='#{edit_user_path(@user)}']", :text=> "Settings")
    end
  end
end
