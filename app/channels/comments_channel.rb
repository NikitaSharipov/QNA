class CommentsChannel < ApplicationCable::Channel
  def follow
    stream_from "question_comments/#{params[:question_id]}"
  end
end
