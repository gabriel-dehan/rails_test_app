require 'spec_helper'

describe PagesController do
  render_views

  before(:each) do
    @base = "| "
  end

  describe "Home page" do
    it "should visit home page" do
      visit root_path
      response.should be_success
    end

    it "should have a correct title" do
      visit root_path
      response.should have_selector("title", content: "#{@base}Home")
    end
  end

  describe "Contact page" do
    it "should visit contact page" do
      visit contact_path
      response.should be_success
    end

    it "should have a correct title" do
      visit contact_path
      response.should have_selector("title", content: "#{@base}Contact")
    end
  end

  describe "About page" do
    it "should visit about page" do
      visit about_path
      response.should be_success
    end

    it "should have a correct title" do
      visit about_path
      response.should have_selector("title", content: "#{@base}About")
    end
    end

  describe "Help page" do
    it "should visit help page" do
      visit help_path
      response.should be_success
    end

    it "should have a correct title" do
      visit help_path
      response.should have_selector("title", content: "#{@base}Help")
    end
  end
end
