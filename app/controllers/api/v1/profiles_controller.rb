class Api::V1::ProfilesController < Api::V1::BaseController
  authorize_resource class: User

  def index
    users = User.where.not(id: current_resource_owner.id)
    render json: users, each_serializer: ProfileSerializer
  end

  def me
    render json: current_resource_owner, serializer: ProfileSerializer
  end
end
