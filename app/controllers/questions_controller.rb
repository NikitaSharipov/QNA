class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]

  expose :questions, ->{ Question.all }
  expose :question, scope: ->{ Question.with_attached_files }
  expose :answer, ->{ Answer.new }

  def new
    question.links.new
  end

  def show
    answer.links.new
  end

  def create
    question.author = current_user

    if question.save
      redirect_to question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def update
    question.update(question_params) if current_user.author_of?(question)
    @exposed_question = question
    if question_params[:links_attributes]
      if question_params[:links_attributes][:_destroy]
        @link_id = question_params[:links_attributes][:id]
        render "shared/delete_link"
      end
    end
  end

  def destroy
    if current_user.author_of?(question)
      question.destroy
      flash[:notice] = 'Your question successfully deleted.'
    else
      flash[:notice] = "You can not delete another user's question"
    end
    redirect_to questions_path
  end

  private

  def question_params
    params.require(:question).permit(:title, :body, files: [], links_attributes: [:id, :name, :url, :_destroy])
  end

end
