module SearchsHelper
  def text_of_resource(resource)
    case resource.class.name
    when 'User'
      resource.email
    when 'Answer', 'Comment'
      resource.body
    when 'Question'
      resource.title
    else
      false
    end
  end

  def searchs_types
    %w(Global User Question Answer Comment)
  end
end
