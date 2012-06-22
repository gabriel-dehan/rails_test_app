require 'spec_helper'

describe "User Pages" do
  before(:each) do
    @base = "| "
  end

  shared_examples_for "all user pages" do
    it { page.should have_selector('title', content: "App #{@base}#{page_title}")}
  end

  describe "register page" do
    let(:page_title) { 'Register' }

    before { visit register_path }

    it_should_behave_like "all user pages"
  end

  describe "profile page" do
    let(:user) { FactoryGirl.create(:user) }
    let(:page_title) { user.name }

    before { visit profile_path(user) }

    it_should_behave_like "all user pages"
    it { page.should have_content(user.email) }
  end
end
