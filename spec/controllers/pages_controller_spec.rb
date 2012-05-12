require 'spec_helper'

describe PagesController do
  render_views

  before(:each) do
    @base = "| "
  end

  describe "GET 'home'" do
    it "should be successful" do
      get 'home'
      response.should be_success
    end

    it "should have a correct title" do
      get 'home'
      response.should have_selector("title", content: "#{@base}Home")
    end
  end

  describe "GET 'contact'" do
    it "should be successful" do
      get 'contact'
      response.should be_success
    end

    it "should have a correct title" do
      get 'contact'
      response.should have_selector("title", content: "#{@base}Contact")
    end
  end

  describe "GET 'about'" do
    it "should be successful" do
      get 'about'
      response.should be_success
    end

    it "should have a correct title" do
      get 'about'
      response.should have_selector("title", content: "#{@base}About")
    end
    end

  describe "GET 'help'" do
    it "should be successful" do
      get 'help'
      response.should be_success
    end

    it "should have a correct title" do
      get 'help'
      response.should have_selector("title", content: "#{@base}Help")
    end
  end
end
