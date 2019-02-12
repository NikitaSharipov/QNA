module Commented
  extend ActiveSupport::Concern

  included do
    before_action :set_commentable, only: [:create_comment, :destroy_comment]
    #    before_action :set_comment, only: [:destroy_comment]
    # before_action :set_body, only: [:create_comment]
  end

  def create_comment
    @commentable.create_comment(current_user, set_body["comment_body"])
    redirect_back(fallback_location: root_path)
  end

  #  def destroy_comment
  #    @commentable.destroy_comment(@comment)
  #  end


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
    #  @body = params[:comment_body]
    params.require(model_name).permit(:comment_body)
  end

  #  def set_comment
  #    @comment = params.find(params[:comment_id])
  #  end

end
