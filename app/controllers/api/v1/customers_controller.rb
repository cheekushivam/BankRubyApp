module Api
    module V1
        class CustomersController < ApplicationController
            rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response
            rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response
            
            def create
                customer = Customer.create(customer_params)
                if customer.save
                    render json: {check: true, status: 'SUCCESS', message: 'Customer Created Successfully', data:customer}, status: :ok
                else
                    render json: {check: false, message: 'Not Created'}, status: :unprocessable_entity    
                end 
            end
        
            def destroy
                customer= Customer.find(params[:id]);
                if customer.destroy
                    render json: {check: true, status: 'SUCCESS', message: 'Deleted Customer Successfully', data:customer}, status: :ok
                end
            end
            
            def update
                customer= Customer.find(params[:id]);
                check = customer.update!(customer_params)
                puts check
                if check
                    render json: {check: true, status: 'SUCCESS', message: 'Updated Customer Successfully', data:customer}, status: :ok
                end
            end    

            def render_not_found_response
                render json: { check: false, message: "Record Not Found" }, status: :not_found
            end

            def render_unprocessable_entity_response
                render json: { check: false, message: "Record Invalid" }, status: :not_found
            end
            
            #Status Method
            def status
                customers= Customer.order('created_at DESC');
                if customers.empty?
                    render json: {check: false, message: 'Records Not Found'}, status: :unprocessable_entity
                else
                    render json: { check: true, status: 'SUCCESS', message: 'Records Loaded', data:customers }, status: :ok
                end    
            end  
            
            def display
                customer= Customer.find_by_id(params[:id]);
                if customer
                    render json: {check: true, status: 'SUCCESS', message: 'Record Found Successfully', data:customer}, status: :ok
                else 
                    render json: {check: false, message: 'Record Not Found'}, status: :unprocessable_entity
                end    
                
            end
        
            private
            def customer_params
              params.permit(:cust_ssnid,:accountant_id,:cust_name,:cust_age,:cust_addr,:cust_state,:cust_city) 
            end    
            
        end 
    end
end            
