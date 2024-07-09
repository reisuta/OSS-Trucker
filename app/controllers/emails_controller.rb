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

    sheet = Google::Sheet.new
    vals = sheet.get_values(Rails.application.credentials.dig(:google, :sheet_id), ['URL一覧!A2:E']).values

    index = 1 #A2開始なので

    vals.each do |url, is_read , repo_name|
      index += 1
      urls.delete(url) if urls.include?(url)
    end

    url_array = []
    url_array = urls.sample(3) if urls.any?

    url_array.each do |url|
      sheet.update_spreadsheet_value(
        Rails.application.credentials.dig(:google, :sheet_id),
        "URL一覧!A#{index+1}",
        Google::Apis::SheetsV4::ValueRange.new(values: [[url]]),
        value_input_option: "USER_ENTERED",
      )

      index += 1
    end

    OssMailer.with(url: url_array).notification.deliver_now
  end
end
