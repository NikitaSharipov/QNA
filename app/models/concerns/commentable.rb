module Commentable
  extend ActiveSupport::Concern

  included do
    has_many :comments, dependent: :destroy, as: :commentable
  end

  def create_comment(user, body)
    comments.create(user: user, body: body)
  end

end
