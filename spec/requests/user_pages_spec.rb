require 'spec_helper'

describe "User Pages" do
  before(:each) do
      @base = "| "
  end

  describe "register page" do
    before { visit register_path }

    it { response.should have_selector('title', content: "App #{@base}Register") }
  end
end
