class SearchsController < ApplicationController

  skip_authorization_check

  def index
    @result = category.search(params[:search], page: params[:page], per_page: 3)
  end

  private

  def category
    if params[:category] == 'Global'
      ThinkingSphinx
    else
      Object.const_get(params[:category]) if Object.const_get(params[:category])
    end
  end

end
