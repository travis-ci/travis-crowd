class ProfileController < ApplicationController
  before_filter :authenticate_user!
end
