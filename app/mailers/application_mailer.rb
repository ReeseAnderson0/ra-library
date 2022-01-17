class ApplicationMailer < ActionMailer::Base
  default from: 'LibraryOverdueNotifier@gmail.com'
  layout 'mailer'
end
