class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :created_at, :updated_at, :short_title, :files
  has_many :comments
  has_many :links

  def short_title
    object.title.truncate(7)
  end

  def files
    object.files.map(&:service_url)
  end
end
