require 'spec_helper'

describe "When registering," do
  before { visit register_path }
  describe 'filling in the form with' do
    describe 'blanks' do
      it 'should not create an user' do
        expect { click_button "Register naow !" }.not_to change(User, :count)
      end
    end

    describe 'invalid informations' do
      it 'should not create an user' do
        expect { click_button "Register naow !" }.not_to change(User, :count)
      end

      describe 'after submission' do
        before { click_button 'Register naow !' }
        it { should have_content 'error' }
      end
    end

    describe 'valid informations' do
      before do
        fill_in 'Name',         with: 'Example User'
        fill_in "Email",        with: "user@example.com"
        fill_in "Password",     with: "foobar"
        fill_in "Re-type your password", with: "foobar"
      end
      it 'should create an user' do
        expect { click_button "Register naow !" }.to change(User, :count).by 1
      end

      describe 'should save the user. After saving the user' do
        before { click_button 'Register naow !' }
        let(:user) { User.find_by_email('user@example.com') }

        it { should have_selector 'title', content: 'profile' }
        it { should have_selector 'div.alert.alert-success', text: 'Greetings' }
        it 'he should be logged in' do
          should have_link 'Logout'
        end
      end
    end

  end
end
