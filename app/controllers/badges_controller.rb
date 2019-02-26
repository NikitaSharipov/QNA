class BadgesController < ApplicationController

  authorize_resource

  def index
    @badges = current_user.badges
  end

end
