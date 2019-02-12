class AnswersController < ApplicationController
  before_action :authenticate_user!
  after_action :publish_answer, only: [:create]
  #  before_action :gon_answer
  include Voted
  include Commented

  expose :question, -> { Question.find(params[:question_id]) }
  expose :answer, scope: ->{ Answer.with_attached_files }

  def create
    @exposed_answer = question.answers.new(answer_params)
    answer.author = current_user
    answer.save

    gon.questionID = question.id
  end

  def update
    answer.update(answer_params) if current_user.author_of?(answer)
    @exposed_question = answer.question
    view_context.delete_link params_links_attributes
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
    params.require(:answer).permit(:body, :comment_body, files: [], links_attributes: [:id, :name, :url, :_destroy])
  end

  def params_links_attributes
    answer_params[:links_attributes]
  end

  def publish_answer
    return if answer.errors.any?

    answer_files = []
    answer.files.map do |file|
      answer_files << { url: url_for(file), name: file.filename.to_s }
    end

    ActionCable.server.broadcast "questions/#{question.id}", { answer: answer.as_json, answer_links: answer.links, answer_files: answer_files }
  end

  #  def gon_answer
  #    gon.answer = answer if answer
  #    gon.user_id = current_user if current_user
  #  end

end
