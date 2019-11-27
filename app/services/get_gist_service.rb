class GetGistService
  def initialize(client: default_client)
    @client = client
  end

  def call(gist_id)
    @client.gist(gist_id)
  end

  private

  def default_client
    Octokit::Client.new
  end
end
