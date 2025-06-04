# app/controllers/api/v1/accounts_controller.rb
module Api
  module V1
    class AccountsController < ApplicationController
      before_action :set_user, only: [:index, :create]
      before_action :set_account, only: [:show, :update, :destroy]
      
      # GET /api/v1/users/:user_id/accounts
      def index
        @accounts = @user.accounts
        render json: @accounts
      end
      
      # GET /api/v1/accounts/:id
      def show
        render json: @account
      end
      
      # POST /api/v1/users/:user_id/accounts
      def create
        # Generar el ID para la nueva cuenta
        account_id = "#{@user.name}-#{@user.accounts.count}"
        
        @account = @user.accounts.new(id: account_id, amount: 0)
        
        if @account.save
          render json: @account, status: :created
        else
          render json: { error: @account.errors.full_messages.join(', ') }, status: :unprocessable_entity
        end
      end
      
      # PUT /api/v1/accounts/:id
      def update
        if @account.update(account_params)
          render json: @account
        else
          render json: { error: @account.errors.full_messages.join(', ') }, status: :unprocessable_entity
        end
      end
      
      # DELETE /api/v1/accounts/:id
      def destroy
        @account.destroy
        head :no_content
      end
      
      private
      
      def set_user
        @user = User.find(params[:user_id])
      end
      
      def set_account
        @account = Account.find(params[:id])
      end
      
      def account_params
        params.require(:account).permit(:amount)
      end
    end
  end
end
