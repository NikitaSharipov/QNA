class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :body, :author_id, :created_at, :updated_at, :files
  has_many :comments
  has_many :links

  def files
    object.files.map{|f| f.service_url}
  end
end
