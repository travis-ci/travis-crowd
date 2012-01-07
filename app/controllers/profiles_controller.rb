class ProfilesController < ApplicationController
  before_filter :authenticate_user!

  def update
    current_user.update_attributes!(params[:user])
    render :json => current_user
  end
end
