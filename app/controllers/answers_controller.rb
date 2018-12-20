class AnswersController < ApplicationController

  expose :question, -> { Question.find(params[:question_id]) }
  expose :answer

  def create
    @exposed_answer = question.answers.new(answer_params)

    if answer.save
      redirect_to answer
    else
      render :new
    end
  end

  def answer_params
    params.require(:answer).permit(:body)
  end

end
