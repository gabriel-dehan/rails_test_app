# == Schema Information
#
# Table name: users
#
#  id              :integer         not null, primary key
#  name            :string(255)
#  email           :string(255)
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#  password_digest :string(255)
#

require 'spec_helper'

describe User do
  before do
    @user = User.new( name: 'Random Name', email: 'rand@mail.com', password: 'foobar',
                      password_confirmation: 'foobar' )
  end

  subject { @user }

  it 'should have a name '                 do should respond_to :name  end
  it 'should have a email'                 do should respond_to :email end
  it 'should have a password digest'       do should respond_to :password_digest end
  it 'should have a password'              do should respond_to :password end
  it 'should have a password confirmation' do should respond_to :password_confirmation end

  it 'should be able to authenticate'     do should respond_to :authenticate end

  it { should be_valid }

  describe 'when name' do
    describe 'is not present' do
      before { @user.name = " " }
      it { should_not be_valid }
    end
    describe 'is too long' do
      before { @user.name = 'a' * 51 }
      it { should_not be_valid }
    end
  end

  describe 'when email' do
    describe 'is not present' do
      before { @user.email = " " }
      it { should_not be_valid }
    end

    describe 'is already taken' do
      before do
        copy = @user.dup
        copy.email.upcase!
        copy.save
      end
      it { should_not be_valid }
    end

    describe 'format is invalid' do
      it 'should invalidate' do
        %w[user@foo,com user_at_foo.org example.user@foo. foo@bar_baz.com foo@bar+baz.com].each do |invalid_address|
          @user.email = invalid_address
          should_not be_valid
        end
      end
    end

    describe 'format is valid' do
      it 'should validate' do
        %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn].each do |valid_address|
          @user.email = valid_address
          should be_valid
        end
      end
    end

    describe 'has uppercase characters' do
      it 'should be downcased' do
        @user.email = 'User@FOO.com'
        @user.save
        @user.email.should match /user@foo.com/
      end
    end
  end

  describe 'when password' do
    describe 'is not present' do
      before { @user.password = @user.password_confirmation = ' ' }
      it { should_not be_valid }
    end

    describe 'is to short' do
      before { @user.password = @user.password_confirmation = 'a * 5' }
      it { should_not be_valid }
    end

    describe 'doesn\'t match' do
      before { @user.password_confirmation = 'mismatch' }
      it { should_not be_valid }
    end

    describe 'is nil' do
      before { @user.password_confirmation = nil }
      it { should_not be_valid }
    end
  end

  describe 'when authenticating' do
    before { @user.save }
    let( :found_user ) { User.find_by_email @user.email }

    describe 'with a valid password' do
      it { should == found_user.authenticate( @user.password ) }
    end
    describe 'with an invalid password' do
      let( :user_with_invalid_password ) { found_user.authenticate( 'invalid' ) }
      specify { user_with_invalid_password.should be_false }
    end
  end
end
