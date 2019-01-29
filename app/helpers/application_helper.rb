module ApplicationHelper
  def delete_link(params_links_attributes)
    if params_links_attributes
      if params_links_attributes[:_destroy]
        @link_id = params_links_attributes[:id]
        render template: "shared/delete_link"
      end
    end
  end
end
