class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true

  validates :name, :url, presence: true
  validates :url, :url => true

  def gist?
    self.url.match?(/https:\/\/gist.github.com\//)
  end

  def gist_content
    gist_id = self.url.split('/').last
    #Контента первого файла в гисте
    GetGistService.new.call(gist_id).files.first[1].content
  end

end
