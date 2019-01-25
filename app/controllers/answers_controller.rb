class AnswersController < ApplicationController

  before_action :authenticate_user!

  expose :question, -> { Question.find(params[:question_id]) }
  expose :answer, scope: ->{ Answer.with_attached_files }

  def create
    @exposed_answer = question.answers.new(answer_params)
    answer.author = current_user
    answer.save
  end

  def update
    answer.update(answer_params) if current_user.author_of?(answer)
    @exposed_question = answer.question
    if params_links_attributes
      if params_links_attributes[:_destroy]
        @link_id = params_links_attributes[:id]
        render "shared/delete_link"
      end
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

  def best
    @answer_best = answer.question.best_answer
    answer.best! if current_user.author_of?(answer.question)
    @answer_best&.reload
  end

  private

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: [:id, :name, :url, :_destroy])
  end

  def params_links_attributes
    answer_params[:links_attributes]
  end

end
