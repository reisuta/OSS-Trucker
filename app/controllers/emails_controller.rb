class EmailsController < ApplicationController
  # TODO: 後に消す
  protect_from_forgery with: :null_session

  def send_notification
    OssMailer.with('test').notification.deliver_now
  end
end
