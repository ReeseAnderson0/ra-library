class SendEmailJob < ApplicationJob
  queue_as :default

  def perform(*args)
    OverdueMailer.overdue_notice.deliver
  end
end
