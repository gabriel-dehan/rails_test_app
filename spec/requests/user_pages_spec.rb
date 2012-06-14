require 'spec_helper'

describe "User Pages" do
  before(:each) do
      @base = "| "
  end

  shared_examples_for "all user pages" do
    it { response.should have_selector('title', content: "App #{@base}#{page_title}")}
  end

  describe "register page" do
    before { visit register_path }

    let(:page_title) { 'Register' }

    it_should_behave_like "all user pages"
  end
end
