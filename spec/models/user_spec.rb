require 'spec_helper'

describe User do
  before(:each) do
    @attr = {
      :name => 'Example User',
      :email => 'user@example.com',
      :password => 'foobar',
      :password_confirmation => 'foobar'
    }
  end

  it 'should create a new instane given valid attributes' do
    User.create!(@attr)
  end

  it 'should require a name' do
    no_name_user = User.new(@attr.merge(:name => ''))
    no_name_user.should_not be_valid
  end

  it 'should require an e-mail address' do
    no_email_user = User.new(@attr.merge(:email => ''))
    no_email_user.should_not be_valid
  end

  it 'should reject names that are too long' do
    long_name = 'X' * 51
    long_name_user = User.new(@attr.merge(:name => long_name))
    long_name_user.should_not be_valid
  end

  it 'should accept valid e-mail addresses' do
    addresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
    addresses.each do |address|
      valid_email_user = User.new(@attr.merge(:email => address))
      valid_email_user.should be_valid
    end
  end

  it 'should reject invalid e-mail addresses' do
    addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
    addresses.each do |address|
      invalid_email_user = User.new(@attr.merge(:email => address))
      invalid_email_user.should_not be_valid
    end
  end

  it 'should reject duplicate e-mail addresses' do
    User.create!(@attr)
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end

  it 'should reject e-mail addresses identical except for case' do
    upcased_email = @attr[:email].upcase
    User.create!(@attr.merge(:email => upcased_email))
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end

  describe 'password validations' do

    it 'should require a password' do
      User.new(@attr.merge(:password => '', :password_confirmation => '')).should_not be_valid
    end

    it 'should require a matching password confirmation' do
      User.new(@attr.merge(:password_confirmation => 'invalid')).should_not be_valid
    end

    it 'should reject short passwords' do
      short = 'x' * 5
      hash = @attr.merge(:password => short, :password_confirmation => short)
      User.new(hash).should_not be_valid
    end

    it 'should reject long passwords' do
      long = 'x' * 41
      hash = @attr.merge(:password => long, :password_confirmation => long)
      User.new(hash).should_not be_valid
    end
  end

  describe 'password encryption' do

    before(:each) do
      @user = User.create!(@attr)
    end

    it 'should have an encrypted password attribute' do
      @user.should respond_to(:encrypted_password)
    end

    it 'should set the encrypted password' do
      @user.encrypted_password.should_not be_blank
    end

    describe 'has_password? method' do

      it 'should be true if the passwords match' do
        @user.has_password?(@attr[:password]).should be_true
      end

      it 'should be false if the passwords do not match' do
        @user.has_password?('invalid').should be_false
      end
    end

    describe 'authenticate method' do

      it 'should return nil on e-mail/password mismatch' do
        wrong_password_user = User.authenticate(@attr[:email], 'wrongpass')
        wrong_password_user.should be_nil
      end

      it 'should return nil for an e-mail address with no user' do
        nonexistent_user = User.authenticate('bar@foo.com', @attr[:password])
        nonexistent_user.should be_nil
      end

      it 'should return the user on e-mail/password match' do
        matching_user = User.authenticate(@attr[:email], @attr[:password])
        matching_user.should == @user
      end
    end
  end

  describe 'admin attribute' do

    before(:each) do
      @user = User.create!(@attr)
    end

    it 'should respond to admin' do
      @user.should respond_to(:admin)
    end

    it 'should not be an admin by default' do
      @user.should_not be_admin
    end

    it 'should be convertible to an admin' do
      @user.toggle!(:admin)
      @user.should be_admin
    end
  end

  describe 'micropost associations' do

    before(:each) do
      @user = User.create(@attr)
      @mp1 = Factory(:micropost, :user => @user, :created_at => 1.day.ago)
      @mp2 = Factory(:micropost, :user => @user, :created_at => 1.hour.ago)
    end

    it 'should have a microposts attribute' do
      @user.should respond_to(:microposts)
    end

    it 'should have the right microposts in the right order' do
      @user.microposts.should == [@mp2, @mp1]
    end

    it 'should delete associated microposts on user deletion' do
      @user.destroy
      [@mp1, @mp2].each do |post|
        lambda do
          Micropost.find(post.id)
        end.should raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
