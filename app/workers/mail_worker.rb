class MailWorker
  include Sidekiq::Worker

  def perform(stmt,flag)

    if flag == 1
      WelcomeMailer.send_email_for_withdraw(stmt).deliver_now!
    end

    if flag == 2
      WelcomeMailer.send_email_for_deposit(stmt).deliver_now!
    end

    if flag == 3
      WelcomeMailer.send_email_for_transfer(stmt).deliver_now!
    end
  end
end
