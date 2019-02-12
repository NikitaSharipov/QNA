class QuestionsController < ApplicationController
  include Voted
  include Commented


  before_action :authenticate_user!, except: [:index, :show]
  before_action :gon_question

  after_action :publish_question, only: [:create]
  after_action :publish_comment, only: [:create_comment]

  expose :questions, ->{ Question.all }
  expose :question, scope: ->{ Question.with_attached_files }
  expose :answer, ->{ Answer.new }

  def new
    question.links.new
    question.badge = Badge.new
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
    view_context.delete_link params_links_attributes
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
    params.require(:question).permit(:title, :body, :comment_body, files: [], links_attributes: [:id, :name, :url, :_destroy], badge_attributes: [:title, :image])
  end

  def params_links_attributes
    question_params[:links_attributes]
  end

  def publish_question
    return if question.errors.any?
    ActionCable.server.broadcast "questions", question: question.as_json
  end

  def gon_question
    gon.questionID = question.id if question
    gon.user_id = current_user.id if current_user
  end

  def publish_comment
    ActionCable.server.broadcast "question_comments/#{question.id}", question_comment: question.comments.last.as_json, question_id: question.id
  end

end
