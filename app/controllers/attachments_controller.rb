class AttachmentsController < ApplicationController
  before_action :authenticate_user!

  def destroy
    @attachment = ActiveStorage::Attachment.find(params[:id])

    authorize! :manage, @attachment

    @attachment.purge if current_user.author_of?(@attachment.record)
  end
end
