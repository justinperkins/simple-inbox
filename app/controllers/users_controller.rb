# Copyright 2009-2010 Justin Perkins
class UsersController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => [:show, :edit, :update, :destroy]
  
  before_filter :load_current_user_into_user, :only => [:show, :edit, :update, :destroy]
  
  def index
    respond_to do |wants|
      wants.html do
        if current_user
          redirect_to user_path(current_user)
        else
          redirect_to new_user_session_path
        end
      end
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      respond_to do |wants|
        wants.html do
          flash[:notice] = "Account registered!"
          redirect_to user_path(@user)
        end
      end
    else
      respond_to do |wants|
        wants.html { render :action => :new }
      end
    end
  end

  def show
    # loaded in before_filter
  end

  def edit
    # loaded in before_filter
  end

  def update
    if @user.update_attributes(params[:user])
      respond_to do |wants|
        wants.html do
          flash[:notice] = "Account updated"
          redirect_to user_path(@user)
        end
      end
    else
      respond_to do |wants|
        wants.html { render :action => :edit }
      end
    end
  end
  
  def destroy
    current_user_session.destroy
    @user.destroy
    respond_to do |wants|
      wants.html do
        flash[:notice] = 'Account deleted'
        redirect_to root_path
      end
    end
  end
  
  private
  def load_current_user_into_user
    # force users to only be able to perform actions on their own accounts
    @user = current_user
  end
end
