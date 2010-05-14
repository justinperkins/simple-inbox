# Copyright 2009-2010 Justin Perkins
class LinkedAccountsController < ApplicationController
  before_filter :require_user
  before_filter :load_current_users_account_into_linked_account, :only => [:edit, :update, :destroy, :activate, :deactivate]
  
  def new
    @linked_account = current_user.linked_account.new
  end
  
  def create
    @linked_account = current_user.linked_account.new(params[:linked_account])
    if @linked_account.save
      respond_to do |wants|
        wants.html do
          flash[:notice] = "Linked account added"
          redirect_to user_path(current_user)
        end
      end
    else
      respond_to do |wants|
        wants.html { render :action => :new }
      end
    end
  end
  
  def edit
    # loaded in before_filter
  end
  
  def update
    if @linked_account.update_attributes(params[:linked_account])
      respond_to do |wants|
        wants.html do
          flash[:notice] = "Linked account updated"
          redirect_to user_path(current_user)
        end
      end
    else
      respond_to do |wants|
        wants.html { render :action => :edit }
      end
    end
  end
  
  def destroy
    @linked_account.destroy
    respond_to do |wants|
      wants.html do
        flash[:notice] = 'Linked account removed'
        redirect_to user_path(current_user)
      end
    end
  end
  
  def activate
    @linked_account.activate!
    respond_to do |wants|
      wants.html do
        flash[:notice] = 'Linked account activated'
        redirect_to edit_linked_account_path(@linked_account)
      end
    end
  end
  
  def deactivate
    @linked_account.deactivate!
    respond_to do |wants|
      wants.html do
        flash[:notice] = 'Linked account activated'
        redirect_to edit_linked_account_path(@linked_account)
      end
    end
  end
  
  private
  
  # users can only manage linked accounts that are their own
  def load_current_users_account_into_linked_account
    @linked_account = current_user.linked_account
    unless @linked_account
      respond_to do |wants|
        wants.html { redirect_to root_path }
      end
    end
  end
end