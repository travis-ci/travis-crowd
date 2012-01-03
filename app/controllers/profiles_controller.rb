class ProfilesController < ApplicationController
  before_filter :authenticate_user!, :only => :show

  def index
    render json: User.with_user_packages.by_package
  end
end
