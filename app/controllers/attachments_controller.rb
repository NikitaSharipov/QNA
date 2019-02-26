class AttachmentsController < ApplicationController

  def destroy
    @attachment = ActiveStorage::Attachment.find(params[:id])

    authorize! :manage, @attachment

    @attachment.purge if current_user.author_of?(@attachment.record)
  end
end
