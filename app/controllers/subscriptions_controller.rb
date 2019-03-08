class SubscriptionsController < ApplicationController
  before_action :authenticate_user!

  authorize_resource

  def create
    @question = Question.find(params[:question_id])
    @subscription = current_user.subscriptions.new(question: @question)

    if !@subscription.save
      head :unprocessable_entity
    end
  end

  def destroy
    @subscription = current_user.subscriptions.find(params[:id])

    if !@subscription.destroy
      head :unprocessable_entity
    end
  end
end
