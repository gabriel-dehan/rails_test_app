class SessionsController < ApplicationController
  def new
    @title = 'Login'
  end

  def create
    user = User.find_by_email( params[:email] )
    if user && user.authenticate( params[:password] )
      sign_in user
      redirect_to profile_path user
    else
      flash.now[:error] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    sign_out
    redirect_to root_path
  end
end
