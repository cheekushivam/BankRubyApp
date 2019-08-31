module Api
    module V1
        class AccountsController < ApplicationController
            rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response
            rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response

            def render_not_found_response
                render json: { check: false, message: "Record Not Found" }, status: :not_found
            end

            def render_unprocessable_entity_response
                render json: { check: false, message: "Record Invalid" }, status: :not_found
            end

            def create
                account = Account.create(account_params)
                if account.save
                    render json: {check: true, status: 'SUCCESS', message: 'Account Created Successfully', data:account}, status: :ok
                else
                    render json: {check: false, message: 'Not Created', data:account.errors}, status: :unprocessable_entity    
                end 
            end

                
            def destroy
                account= Account.find(params[:id]);
                if account.destroy
                    render json: {check: true, status: 'SUCCESS', message: 'Deleted Account Successfully', data:account}, status: :ok
                end
            end
            
            #Account_status Method
            def status
                accounts= Account.order('created_at DESC');
                if accounts.empty?
                    render json: {check: false, message: 'No Records Exists'}, status: :unprocessable_entity
                else
                    render json: { check: true, status: 'SUCCESS', message: 'Records Loaded', data:accounts }, status: :ok
                end  
            end 

            #Search Method
            def search
                account= Account.find_by_id(params[:id]);
                if account
                    render json: {check: true, status: 'SUCCESS', message: 'Record Found Successfully', data:account}, status: :ok
                else 
                    render json: {check: false, message: 'Record Not Found'}, status: :unprocessable_entity
                end    
            end 
              
            private
            def account_params
                params.permit(:acc_type,:acc_balance,:customer_id)
            end    
        end 
    end
end           