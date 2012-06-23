require 'spec_helper'

describe "Authentication" do
  describe "login page " do
    subject { page }
    before { visit login_path }

    describe "should be visited" do
      it { should have_selector 'title', content: 'Login' }
    end

    describe 'login form' do
      describe 'with invalid credentials' do
        before { click_button 'Login' }
        it { should have_selector 'div.alert.alert-error', text: 'Invalid' }

        describe 'after visiting another page' do
          before { click_link 'Home' }
          it { should_not have_selector 'div.alert.alert-error' }
        end
      end

      describe 'with valid credentials' do
        let(:user) { FactoryGirl.create :user }
        before do
          fill_in 'Email',    with: user.email
          fill_in 'Password', with: user.password
          click_button 'Login'
        end

        it { should have_selector 'title', content: 'Profile' }
        it { should have_link 'Profile', href: profile_path( user ) }
        it { should have_link 'Logout', href: logout_path }
        it { should_not have_link 'Register', href: register_path }

        describe 'followed by a logout' do
          before { click_link 'Logout' }
          it { should have_link 'Login' }
        end
      end
    end
  end
end
