require 'spec_helper'

describe PagesController do

  render_views

  before(:each) do 
    @base_title = "Ruby on Rails Tutorial Sample App"
  end

  describe "GET 'home'" do
    it "should have the content 'Home'" do
      get 'home'
      expect(response).to be_success
    end
    
    it "should have the title 'Ruby on Rails Tutorial Sample App | Home'" do
      get 'home'
      expect(response).to have_selector("title", content: "#{@base_title} | Home") 
    end

  end

  describe "GET 'contact'" do
    it "returns http success" do
      get 'contact'
      expect(response).to be_success
    end

    it "should have the title 'Ruby on Rails Tutorial Sample App | Contact'" do
      get 'contact'
      expect(response).to have_selector("title", content: "#{@base_title} | Contact")
    end

  end

  describe "GET 'about'" do
    it "returns http success" do
      get 'about'
      expect(response).to be_success
    end

    it "should have the title 'Ruby on Rails Tutorial Sample App | About'" do
      get 'about'
      expect(response).to have_selector("title", content: "#{@base_title} | About")
    end
  end

  describe "GET 'help'" do
    it "returns http success" do
      get 'help'
      expect(response).to be_success
    end

    it "should have the title 'Ruby on Rails Tutorial Sample App | Help'" do
      get 'help'
      expect(response).to have_selector("title", content: "#{@base_title} | Help")
    end
  end  


end

