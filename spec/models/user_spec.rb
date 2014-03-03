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
  end  

end
