module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: %i[vote_up vote_down cancel]
  end

  def vote_up
    @votable.vote_up(current_user)
    render json: { rating: @votable.rating, id: @votable.id, vote_value: @votable.vote_value(current_user) }
  end

  def vote_down
    @votable.vote_down(current_user)
    render json: { rating: @votable.rating, id: @votable.id, vote_value: @votable.vote_value(current_user) }
  end

  def cancel
    @votable.cancel(current_user)
    render json: { rating: @votable.rating, id: @votable.id }
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def set_votable
    @votable = model_klass.find(params[:id])
  end
end
