class PagesController < ApplicationController
  def splash
    redirect_to home_path if current_user
  end
end