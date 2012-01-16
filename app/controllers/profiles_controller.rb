class ProfilesController < ApplicationController
  before_filter :authenticate_user!

  def update
    current_user.update_attributes!(params[:user])
    render :json => current_user
  end

  def ringtone
    if track = Track.find(permalink: params[:permalink])
      redirect_to track.download_url
    else
      render text: 'File Not Found', status: 404
    end
  end
end
