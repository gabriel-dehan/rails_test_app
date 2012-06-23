class UsersController < ApplicationController
  def new
    @title = 'Register'
    @user = User.new
  end

  def create
    @user = User.new params[:user]
    if @user.save
      sign_in @user
      flash[:success] = 'Greetings, ' + @user.name
      redirect_to profile_path @user
    else
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
    @title = @user.name
  end
end