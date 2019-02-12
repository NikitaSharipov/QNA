class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    comment = commentable.comments.new(comment_params)
    comment.author = current_user
    comment.save
  end

  private


end
