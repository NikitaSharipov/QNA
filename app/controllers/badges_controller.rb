class BadgesController < ApplicationController
  before_action :authenticate_user!

  authorize_resource

  def index
    @badges = current_user.badges
  end
end
