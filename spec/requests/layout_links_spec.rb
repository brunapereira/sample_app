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
end
