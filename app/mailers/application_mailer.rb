class ApplicationMailer < ActionMailer::Base
  default from: "from@example.com"
  layout "mailer"

  before_action :attach_email_header

  def attach_email_header
    headers['X-SYSTEM-PROCESS-ID'] = Process.pid
  end
end
