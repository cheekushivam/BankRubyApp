class WelcomeMailer < ApplicationMailer
    
    def send_welcome_mail
        mail(to: "guptashivam1509@gmail.com",subject: "Notification from cheekuShivam Bank")
    end

    def send_email_for_bankAccountCreation
        mail(to: "guptashivam1509@gmail.com",subject: "Notification from cheekuShivam Bank")
    end

    def send_email_for_CustomerCreation
        mail(to: "guptashivam1509@gmail.com",subject: "Notification from cheekuShivam Bank")
    end

    def send_email_for_AccountantCreation
        mail(to: "guptashivam1509@gmail.com",subject: "Notification from cheekuShivam Bank")
    end

    def send_email_for_withdraw(statement)
        @statement = statement
        mail(to: "guptashivam1509@gmail.com",subject: "Notification from cheekuShivam Bank")
    end 
    
    def send_email_for_deposit(statement)
        @statement = statement
        mail(to: "guptashivam1509@gmail.com",subject: "Notification from cheekuShivam Bank")
    end

    def send_email_for_transfer(statement)
        @statement = statement
        mail(to: "guptashivam1509@gmail.com",subject: "Notification from cheekuShivam Bank")
    end
end
