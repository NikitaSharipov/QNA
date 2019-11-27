class Services::SearchSphinxService
  include SearchsHelper

  def search(category_name, search_value, page)
    category(category_name).search(escape(search_value), page: page, per_page: 3) if valid_input?(category_name, search_value)
  end

  private

  def category(category_name)
    category_name == 'Global' ? ThinkingSphinx : category_name.constantize
  end

  def escape(search_value)
    ThinkingSphinx::Query.escape(search_value)
  end

  def valid_input?(category_name, search_value)
    searchs_types.include?(category_name) && search_value.present?
  end
end
