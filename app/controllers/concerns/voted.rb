module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: [:vote_up, :vote_down]
  end

  def vote_up
    @votable.vote_up(current_user)
    render json: {rating: @votable.rating, id: @votable.id }
  end

  def vote_down
    @votable.vote_down(current_user)
    render json: {rating: @votable.rating, id: @votable.id }
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def set_votable
    @votable = model_klass.find(params[:id])
  end

end
