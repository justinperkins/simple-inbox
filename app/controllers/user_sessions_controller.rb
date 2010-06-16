# Copyright 2009-2010 Justin Perkins
class UserSessionsController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => :destroy
  
  def new
    @user_session = UserSession.new
  end
  
  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      respond_to do |wants|
        wants.html do
          flash[:notice] = "Login successful!"
          redirect_to overview_user_path(@user_session.record)
        end
      end
    else
      respond_to do |wants|
        wants.html { render :action => :new }
      end
    end
  end
  
  def destroy
    current_user_session.destroy
    respond_to do |wants|
      wants.html do
        flash[:notice] = "Logout successful!"
        redirect_to new_user_session_url
      end
    end
  end
end
