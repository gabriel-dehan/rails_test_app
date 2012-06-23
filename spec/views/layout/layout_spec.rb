require 'spec_helper'
require 'capybara/rspec'
include Capybara::DSL

describe 'Layout' do
  before { visit root_path }

  describe 'Header' do
    it 'should have the right links' do
      click_link 'Register'
      page.should have_selector 'title', content:'Register'
      click_link 'Home'
      page.should have_selector 'title', content:'Home'
      click_link 'About'
      page.should have_selector 'title', content:'About'
      click_link 'Contact'
      page.should have_selector 'title', content:'Contact'
      click_link 'Help'
      page.should have_selector 'title', content:'Help'
    end
  end
end