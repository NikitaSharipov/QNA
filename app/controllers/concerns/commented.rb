module Commented
  extend ActiveSupport::Concern

  included do
    before_action :set_commentable, only: %i[create_comment destroy_comment]
  end

  def create_comment
    @commentable.create_comment(current_user, set_body["comment_body"])
    redirect_back(fallback_location: root_path)
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def model_name
    controller_name.slice(0..-2).to_sym
  end

  def set_commentable
    @commentable = model_klass.find(params[:id])
  end

  def set_body
    params.require(model_name).permit(:comment_body)
  end
end
