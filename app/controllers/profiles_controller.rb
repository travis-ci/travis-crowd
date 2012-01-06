class ProfilesController < ApplicationController
  before_filter :authenticate_user!, :only => :show
end
