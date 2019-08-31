module Api
    module V1
        class AccountantsController < ApplicationController
            rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response
            rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response
            def create
                accountant = Accountant.create(accountant_params)
                if accountant.save
                    render json: {check: true, status: 'SUCCESS', message: 'Accountant Created Successfully', data:accountant}, status: :ok
                else
                    render json: {check: false, message: 'Not Created'}, status: :unprocessable_entity    
                end 
            end

            def render_not_found_response
                render json: { check: false, message: "Record Not Found" }, status: :not_found
            end

            def render_unprocessable_entity_response
                render json: { check: false, message: "Record Invalid" }, status: :not_found
            end

            def createAccountStatement(statement)
                stmt = AcctStatement.new
                stmt.action = statement[:action]
                stmt.message = statement[:message]
                stmt.acc_sender_id = statement[:acc_sender_id]
                stmt.acc_receiver_id = statement[:acc_receiver_id]
                stmt.balance = statement[:balance]
                stmt.cust_sender_id = statement[:cust_sender_id]
                stmt.cust_receiver_id = statement[:cust_receiver_id]
                stmt.acct_sender_id = statement[:acct_sender_id]
                stmt.acct_receiver_id = statement[:acct_receiver_id]
                stmt.save
                return stmt
            end

            def withdraw_money
                amount = params[:amount]
                id = params[:id]
                account = Account.find_by_id(id)
                if account
                    if amount.to_i < account.acc_balance.to_i
                        updatedAmount = account.acc_balance.to_i - amount.to_i
                        account.update(acc_balance: updatedAmount.to_s)
                        statement = {
                            action: "Debit",
                            message: "A/c XXX#{account.id} is debited by Rs. #{amount} on #{Date.current}, Available Balance is Rs. #{account.acc_balance}",
                            acc_sender_id: id,
                            acc_receiver_id: id,
                            balance: account.acc_balance,
                            cust_sender_id: account.customer_id,
                            cust_receiver_id: account.customer_id,
                            acct_sender_id: Customer.find_by_id(account.customer_id).accountant.id,
                            acct_receiver_id: Customer.find_by_id(account.customer_id).accountant.id
                        }
                        stmt = createAccountStatement(statement)
                        MailJob.perform_now(stmt[:message],1)
                        #WelcomeMailer.send_email_for_withdraw(stmt).deliver_now!
                        render json: { check: true, status: "Success", message: "Amount Successfully Withdrawn", data: account}, status: :ok
                    else
                        render json: { check: false, status: "Error", message: "Not Sufficient Balance"}, status: :unprocessable_entity
                    end        
                else
                    render json: {check: false, message: 'Record Not Found'}, status: :unprocessable_entity
                end    
            end
            
            def deposit_money
                id = params[:id]
                amount = params[:amount]
                account = Account.find_by_id(id)
                if account
                    updatedAmount = account.acc_balance.to_i + amount.to_i
                    account.update(acc_balance: updatedAmount.to_s)
                    statement = {
                        action: "Credit",
                        message: "A/c XXX#{account.id} is credited by Rs. #{amount} on #{Date.current}, Available Balance is Rs. #{account.acc_balance}",
                        acc_sender_id: id,
                        acc_receiver_id: id,
                        balance: account.acc_balance,
                        cust_sender_id: account.customer_id,
                        cust_receiver_id: account.customer_id,
                        acct_sender_id: Customer.find_by_id(account.customer_id).accountant.id,
                        acct_receiver_id: Customer.find_by_id(account.customer_id).accountant.id
                    }
                    stmt = createAccountStatement(statement)
                    MailJob.perform_now(stmt[:message],2)
                    #WelcomeMailer.send_email_for_deposit(stmt).deliver_now!
                    render json: { check: true, status: "Success", message: "Amount Successfully Added", data: account}, status: :ok
                else
                    render json: {check: false, message: 'Record Not Found'}, status: :unprocessable_entity
                end    
            end

            def printStatementAllTransactions
                statements= AcctStatement.order('created_at DESC');
                if statements.empty?
                    render json: {check: false, message: 'Records Not Found'}, status: :unprocessable_entity
                else
                    render json: { check: true, status: 'SUCCESS', message: 'Records Loaded', data:statements }, status: :ok
                end 
            end

            def transfer_money
                amountSender = params[:amountSender]
                idSender = params[:idSender]
                idReceiver = params[:idReceiver]
                accountSender = Account.find_by_id(idSender)
                accountReceiver = Account.find_by_id(idReceiver)

                if accountSender && accountReceiver
                    if accountSender.acc_balance.to_i > amountSender.to_i   
                        updatedAmountSender = accountSender.acc_balance.to_i - amountSender.to_i
                        accountSender.update(acc_balance: updatedAmountSender.to_s)
                        updatedAmountReceiver = accountReceiver.acc_balance.to_i + amountSender.to_i
                        accountReceiver.update(acc_balance: updatedAmountReceiver.to_s)
                        statementSender = {
                            action: "Transfer",
                            message: "A/c XXX#{idSender} is debited by Rs. #{amountSender} on #{Date.current}, Available Balance is Rs. #{accountSender.acc_balance}",
                            acc_sender_id: idSender,
                            acc_receiver_id: idReceiver,
                            balance: accountSender.acc_balance,
                            cust_sender_id: accountSender.customer_id,
                            cust_receiver_id: accountReceiver.customer_id,
                            acct_sender_id: Customer.find_by_id(accountSender.customer_id).accountant.id,
                            acct_receiver_id: Customer.find_by_id(accountReceiver.customer_id).accountant.id
                        }
                        stmt = createAccountStatement(statementSender)
                        #MailWorker.perform_in(1.minutes,stmt[:message],3)
                        MailJob.perform_now(stmt[:message],3)
                        #WelcomeMailer.send_email_for_transfer(stmt[:message]).deliver_later
                        statementReceiver = {
                            action: "Transfer",
                            message: "A/c XXX#{idReceiver} is credited by Rs. #{amountSender} on #{Date.current}, Available Balance is Rs. #{accountReceiver.acc_balance}",
                            acc_sender_id: idSender,
                            acc_receiver_id: idReceiver,
                            balance: accountReceiver.acc_balance,
                            cust_sender_id: accountSender.customer_id,
                            cust_receiver_id: accountReceiver.customer_id,
                            acct_sender_id: Customer.find_by_id(accountSender.customer_id).accountant.id,
                            acct_receiver_id: Customer.find_by_id(accountReceiver.customer_id).accountant.id
                        }
                        stmt = createAccountStatement(statementReceiver)
                        #MailWorker.perform_in(1.minutes,stmt[:message],3)
                        MailJob.perform_now(stmt[:message],3)
                        #WelcomeMailer.send_email_for_transfer(stmt[:message]).deliver_later
                        render json: {check: true, status: "Success", message: "Transfer Successfully Completed", data: [
                            acc_sender: accountSender,
                            acc_receiver: accountReceiver
                        ]}, status: :ok
                    else
                        render json: { check: false, status: "Error", message: "Not Sufficient Balance"}, status: :unprocessable_entity
                    end    
                else
                    render json: {check: false, message: 'Record Not Found'}, status: :unprocessable_entity
                end
            end

            private
            def accountant_params
                params.permit(:acct_ssnid,:acct_name,:acct_age,:acct_addr,:acct_state,:acct_city,:acct_designation) 
            end
        end 
    end
end           