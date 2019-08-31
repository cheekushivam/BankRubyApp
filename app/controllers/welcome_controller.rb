class WelcomeController < ApplicationController
    def send_email
        WelcomeMailer.send_welcome_mail.deliver_now!
    end
end
