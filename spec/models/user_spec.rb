# == Schema Information
#
# Table name: users
#
#  id                 :integer          not null, primary key
#  name               :string(255)
#  email              :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  encrypted_password :string(255)
#  salt               :string(255)
#  admin              :boolean          default(FALSE)
#

require 'spec_helper'

describe User do
  
  before(:each) do 
    @attr = { name: "user", email: "user@example.com", password: "foobar", password_confirmation: "foobar" }
  end
   
  it "should create a new instance given a valid attribute" do 
    User.create!(@attr)
  end

  it "should require a name" do 
    no_name_user = User.new(@attr.merge(name: ""))
    expect(no_name_user).to_not be_valid
  end

  it "should require a email address" do 
    no_email_user = User.new(@attr.merge(email: ""))
    expect(no_email_user).to_not be_valid
  end

  it "should reject names that are too long" do 
    long_name = "a" * 51
    long_name_user = User.new(@attr.merge(name:long_name))
    expect(long_name_user).to_not be_valid
  end

  it "should accept valid email addresses" do 
    addresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
    addresses.each do |address|
      valid_email_user = User.new(@attr.merge(email:address))
      expect(valid_email_user).to be_valid
    end
  end

  it "should reject invalid email addresses" do 
    addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
    addresses.each do |address|
      invalid_email_user = User.new(@attr.merge(email:address))
      expect(invalid_email_user).to_not be_valid
    end
  end

  it "should reject duplicate email addresses" do 
    User.create!(@attr)
    user_with_duplicate_email = User.new(@attr)
    expect(user_with_duplicate_email).to_not be_valid
  end

  describe "passwords" do 
      
      before(:each) do 
        @user = User.new(@attr)
      end  

      it "should have a password attribute" do 
        expect(@user).to respond_to(:password)
      end

      it "should have a password confirmation attribute" do 
        expect(@user).to respond_to(:password)
      end
    end

  describe "password validations" do 
    it "should require a password" do 
      expect(User.new(@attr.merge(password: "", password_confirmation: ""))).to_not be_valid
    end

    it "should require a matching password confirmation" do 
      expect(User.new(@attr.merge(password_confirmation: "invalid"))).to_not be_valid
    end

    it "should reject short passwords" do 
      short = "a" * 5
      hash = @attr.merge(password: short, password_confirmation: short) 
      expect(User.new(hash)).to_not be_valid
    end

    it "should reject long passwords" do 
      long = "a" * 41
      hash = @attr.merge(password: long, password_confirmation: long) 
      expect(User.new(hash)).to_not be_valid
    end
  end  

  describe "password encryption" do 

    before(:each) do 
      @user = User.create!(@attr)
    end
    
    it "should have an encrypted password attribute" do 
      expect(@user).to respond_to(:encrypted_password)
    end    

    it "should set the encrypted password attribute" do 
      expect(@user.encrypted_password).to_not be_blank
    end

    it "should have a sault" do
      expect(@user).to respond_to(:salt)
    end


    describe "has_password? method" do 
      it "should exist" do 
        expect(@user).to respond_to(:has_password?)
      end

      it "should return true if de passwords match" do 
        expect(@user.has_password?(@attr[:password])).to be_true
      end

      it "should return false if the passwords don't match" do 
        expect(@user.has_password?("invalid")).to be_false
      end
    end

    describe "authenticate method" do 

      it "should exist" do 
        expect(User).to respond_to :authenticate 
      end

      it "should return nil on email/password mismatch" do
        expect(User.authenticate(@attr[:email], "wrongpass")).to be_nil
      end

      it "should return nil for an email address with no user" do 
        expect(User.authenticate("bar@foo.com", @attr[:password])).to be_nil
      end

      it "should return the user on email/password match" do 
        expect(User.authenticate(@attr[:email], @attr[:password])).to be == @user
      end
    end
  end  

  describe "admin attribute" do 

    before(:each) do 
      @user = User.create! @attr
    end
  
    it "should respond to admin" do
      expect(@user).to respond_to :admin 
    end

    it "should not be an admin by default" do
      expect(@user).to_not be_admin
    end

    it "should be convertible to an admin" do
      @user.toggle! :admin
      expect(@user).to be_admin
    end
  end

  describe "micropost associations" do 

    before :each do 
      @user = User.create(@attr)
      @mp1 = Factory(:micropost, user: @user, created_at: 1.day.ago)
      @mp2 = Factory(:micropost, user: @user, created_at: 1.hour.ago)
    end

    it "should have a microposts attribute" do 
      expect(@user).to respond_to :microposts
    end

    it "should have the right microposts in the right order" do 
      expect(@user.microposts).to eq [@mp2, @mp1]
    end

    it "should destroy associated microposts" do 
      @user.destroy
      [@mp1, @mp2].each do |micropost|
        lambda do 
          Micropost.find(micropost)
        end.should raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
