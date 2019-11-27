class SubscriptionsController < ApplicationController
  before_action :authenticate_user!

  authorize_resource

  def create
    @question = Question.find(params[:question_id])
    @subscription = current_user.subscriptions.new(question: @question)

    head :unprocessable_entity unless @subscription.save
  end

  def destroy
    @subscription = current_user.subscriptions.find(params[:id])

    head :unprocessable_entity unless @subscription.destroy
  end
end
