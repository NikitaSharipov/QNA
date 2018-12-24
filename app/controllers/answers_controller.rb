class AnswersController < ApplicationController

  before_action :authenticate_user!, except: [:index, :show]

  expose :question, -> { Question.find(params[:question_id]) }
  expose :answer

  def create
    @exposed_answer = question.answers.new(answer_params)

    if answer.save
      redirect_to answer, notice: 'Your answer successfully created.'
    else
      render :new
    end
  end

  def answer_params
    params.require(:answer).permit(:body)
  end

end
