class AnswersChannel < ApplicationCable::Channel
  def follow
    byebug
    stream_from "questions/#{params[:question_id]}"
    #stream_from "answers"
  end
end
