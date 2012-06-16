require 'spec_helper'

describe PagesController do
  render_views

  before(:each) do
    @base = "| "
  end

  describe "GET 'home'" do
    before { visit root_path }

    it "should be successful" do
      response.should be_success
    end

    it "should have a correct title" do
      response.should have_selector("title", content: "#{@base}Home")
    end
  end

  describe "GET 'contact'" do
    before { visit contact_path }
    it "should be successful" do
      response.should be_success
    end

    it "should have a correct title" do
      response.should have_selector("title", content: "#{@base}Contact")
    end
  end

  describe "GET 'about'" do
    before { visit about_path }
    it "should be successful" do
      response.should be_success
    end

    it "should have a correct title" do
      response.should have_selector("title", content: "#{@base}About")
    end
    end

  describe "GET 'help'" do
    before { visit help_path }
    it "should be successful" do
      response.should be_success
    end

    it "should have a correct title" do
      response.should have_selector("title", content: "#{@base}Help")
    end
  end
end
