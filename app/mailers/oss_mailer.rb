class OssMailer < ApplicationMailer
  default from: Rails.application.credentials.dig(:smtp, :user_name)

  def notification
    mail(to: Rails.application.credentials.dig(:smtp, :email), subject: '本日のPR/Issueです')
  end
end
