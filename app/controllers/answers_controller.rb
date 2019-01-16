class AnswersController < ApplicationController

  before_action :authenticate_user!

  expose :question, -> { Question.find(params[:question_id]) }
  expose :answer

  def create
    @exposed_answer = question.answers.new(answer_params)
    answer.author = current_user
    answer.save
  end

  def update
    answer.update(answer_params) if current_user.author_of?(answer)
    @exposed_question = answer.question
  end

  def destroy
    if current_user.author_of?(answer)
      answer.destroy
      flash[:notice] = 'Your answer successfully deleted.'
    else
      flash[:notice] = "You can not delete another user's answer"
    end
    redirect_to answer.question
  end

  def best
    @answer_best = answer.question.best_answer
    answer.best! if current_user.author_of?(answer.question)
    @answer_best&.reload
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end

end
