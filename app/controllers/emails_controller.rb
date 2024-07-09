class EmailsController < ApplicationController
  def send_notification
    owner = 'rails' # 取得したいリポジトリのオーナー名
    repo = 'rails'  # 取得したいリポジトリ名
    token = Rails.application.credentials.github[:personal_access_token]

    service = Github::Service.new(owner, repo, token)
    issues = service.fetch_issues
    pull_requests = service.fetch_pull_requests

    urls = issues.map { |issue| issue['html_url'] unless issue.key?('pull_request') }.compact
    urls += pull_requests.map { |pr| pr['html_url'] }

    url_array = []
    url_array = urls.sample(3) if urls.any?

    sheet = Google::Sheet.new
    val = sheet.get_values(Rails.application.credentials.dig(:google, :sheet_id), ['URL一覧!A2:E']).values
    OssMailer.with(url: url_array).notification.deliver_now
  end
end
