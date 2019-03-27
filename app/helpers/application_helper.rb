module ApplicationHelper
  def delete_link(params_links_attributes)
    if params_links_attributes
      if params_links_attributes[:_destroy]
        @link_id = params_links_attributes[:id]
        render template: "shared/delete_link"
      end
    end
  end

  def collection_cache_key_for(model)
    klass = model.to_s.capitalize.constantize
    count = klass.count
    max_updated_at = klass.maximum(:updated_at).try(:utc).try(:to_s, :number)
    "#{model.to_s.pluralize}/collection-#{count}-#{max_updated_at}"
  end
end
