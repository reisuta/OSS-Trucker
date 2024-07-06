class Github::Service
  def initialize(owner, repo, token)
    @owner = owner
    @repo = repo
    @api = Github::Api.new(token)
  end

  def fetch_issues
    @api.get("/repos/#{@owner}/#{@repo}/issues")
  end

  def fetch_pull_requests
    # 仮にRailsのPRは5万近くあるので、600ぐらいを最大値として仮定
    page = rand(1..600)

    @api.get("/repos/#{@owner}/#{@repo}/pulls", { state: 'all', sort: 'created', direction: 'asc', page: page, per_page: 100})
  end
end
