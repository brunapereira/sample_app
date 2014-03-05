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
end
