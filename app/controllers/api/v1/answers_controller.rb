class Api::V1::AnswersController < Api::V1::BaseController
  authorize_resource

  def index
    answers = question.answers
    render json: answers, each_serializer: AnswersSerializer
  end

  def show
    render json: answer
  end

  def create
    answer = question.answers.new(answer_params)
    answer.author = current_resource_owner

    if answer.save
      render json: answer, status: :created
    else
      render json: answer.errors.full_messages, status: :unprocessable_entity
    end
  end

  def update
    if answer.update(answer_params)
      render json: answer, status: :ok
    else
      render json: answer.errors.full_messages, status: :unprocessable_entity
    end
  end

  def destroy
    answer.destroy
  end

  private

  def answer
    @answer ||= Answer.find(params[:id])
  end

  def question
    @question ||= Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
