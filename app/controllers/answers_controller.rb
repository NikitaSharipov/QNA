class AnswersController < ApplicationController

  before_action :authenticate_user!

  expose :question, -> { Question.find(params[:question_id]) }
  expose :answer

  def create
    @exposed_answer = question.answers.new(answer_params)
    answer.author = current_user

    if answer.save
      redirect_to question, notice: 'Your answer successfully created.'
    else
      render 'questions/show'
    end
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

  private

  def answer_params
    params.require(:answer).permit(:body)
  end

end
