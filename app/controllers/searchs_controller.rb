class SearchsController < ApplicationController

  skip_authorization_check

  def index
    @result = Services::SearchSphinxService.new.search(params[:category], params[:search], params[:page])
  end

end
