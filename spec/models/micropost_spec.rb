require 'spec_helper'

describe Micropost do

  before :each do 
    @user = Factory :user
    @attr = { content: "loren ipsum" }
  end

  it "should create a new instance with valid attributes" do 
    @user.microposts.create!(@attr)
  end

  describe "user associations" do

    before :each do 
      @micropost = @user.microposts.create(@attr)
    end

    it "should have a user attribute" do 
      expect(@micropost).to respond_to :user
    end

    it "should have the right associated user" do 
      expect(@micropost.user_id).to eql @user.id
      expect(@micropost.user).to eql @user
    end
  end

end
