require "test_helper"

class OverdueMailerTest < ActionMailer::TestCase
  test "overdue_notice" do
    mail = OverdueMailer.overdue_notice
    assert_equal "Overdue notice", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
