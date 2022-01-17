# Preview all emails at http://localhost:3000/rails/mailers/overdue_mailer
class OverdueMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/overdue_mailer/overdue_notice
  def overdue_notice
    OverdueMailer.overdue_notice
  end

end
