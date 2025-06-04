# app/controllers/api/v1/transactions_controller.rb
module Api
  module V1
    class TransactionsController < ApplicationController
      before_action :set_account, only: [:index, :deposit, :withdrawal, :transfer]
      
      # GET /api/v1/accounts/:account_id/transactions
      def index
        transactions = @account.all_transactions
        
        # Formatear las transacciones en el formato esperado por el frontend
        result = []
        current_amount = @account.amount
        
        transactions.each do |transaction|
          # Añadir la transacción con el saldo después de aplicarla
          transaction_info = {
            amount: current_amount,
            transaction: {
              id: transaction.id,
              transaction_type: transaction.transaction_type,
              amount: transaction.amount,
              origin_account: transaction.origin_account,
              destiny_account: transaction.destiny_account,
              created_at: transaction.created_at,
              description: transaction.to_s
            }
          }
          
          result << transaction_info
          
          # Ajustar el saldo para la siguiente transacción
          case transaction.transaction_type
          when Transaction::DEPOSIT
            current_amount -= transaction.amount if transaction.origin_account == @account.id
          when Transaction::WITHDRAWAL
            current_amount += transaction.amount if transaction.origin_account == @account.id
          when Transaction::TRANSFER
            if transaction.origin_account == @account.id
              current_amount += transaction.amount
            elsif transaction.destiny_account == @account.id
              current_amount -= transaction.amount
            end
          end
        end
        
        render json: result
      end
      
      # POST /api/v1/accounts/:account_id/deposit
      def deposit
        amount = transaction_params[:amount].to_f
        
        # Validar monto
        if amount <= 0
          return render json: { error: "Amount must be greater than 0" }, status: :unprocessable_entity
        end
        
        # Crear el ID de la transacción
        user = @account.user
        transaction_id = "#{user.name}-#{Transaction.count}-#{amount}"
        
        # Crear la transacción
        transaction = Transaction.new(
          id: transaction_id,
          transaction_type: Transaction::DEPOSIT,
          amount: amount,
          origin_account: @account.id,
          destiny_account: @account.id
        )
        
        if transaction.save
          # Aplicar la transacción
          begin
            transaction.apply
            render json: { account: @account, transaction: transaction }
          rescue StandardError => e
            transaction.destroy
            render json: { error: e.message }, status: :unprocessable_entity
          end
        else
          render json: { error: transaction.errors.full_messages.join(', ') }, status: :unprocessable_entity
        end
      end
      
      # POST /api/v1/accounts/:account_id/withdrawal
      def withdrawal
        amount = transaction_params[:amount].to_f
        
        # Validar monto
        if amount <= 0
          return render json: { error: "Amount must be greater than 0" }, status: :unprocessable_entity
        end
        
        # Validar fondos suficientes
        if @account.amount < amount
          return render json: { error: "Insufficient funds" }, status: :unprocessable_entity
        end
        
        # Crear el ID de la transacción
        user = @account.user
        transaction_id = "#{user.name}-#{Transaction.count}-#{amount}"
        
        # Crear la transacción
        transaction = Transaction.new(
          id: transaction_id,
          transaction_type: Transaction::WITHDRAWAL,
          amount: amount,
          origin_account: @account.id,
          destiny_account: @account.id
        )
        
        if transaction.save
          # Aplicar la transacción
          begin
            transaction.apply
            render json: { account: @account, transaction: transaction }
          rescue StandardError => e
            transaction.destroy
            render json: { error: e.message }, status: :unprocessable_entity
          end
        else
          render json: { error: transaction.errors.full_messages.join(', ') }, status: :unprocessable_entity
        end
      end
      
      # POST /api/v1/accounts/:account_id/transfer
      def transfer
        amount = transaction_params[:amount].to_f
        destiny_account_id = transaction_params[:destiny_account_id]
        
        # Validar monto
        if amount <= 0
          return render json: { error: "Amount must be greater than 0" }, status: :unprocessable_entity
        end
        
        # Validar fondos suficientes
        if @account.amount < amount
          return render json: { error: "Insufficient funds" }, status: :unprocessable_entity
        end
        
        # Buscar la cuenta destino
        destiny_account = Account.find_by(id: destiny_account_id)
        unless destiny_account
          return render json: { error: "Destiny account not found" }, status: :not_found
        end
        
        # Crear el ID de la transacción
        user = @account.user
        transaction_id = "#{user.name}-#{Transaction.count}-#{amount}"
        
        # Crear la transacción
        transaction = Transaction.new(
          id: transaction_id,
          transaction_type: Transaction::TRANSFER,
          amount: amount,
          origin_account: @account.id,
          destiny_account: destiny_account.id
        )
        
        if transaction.save
          # Aplicar la transacción
          begin
            transaction.apply
            render json: { 
              origin_account: @account, 
              destiny_account: destiny_account, 
              transaction: transaction 
            }
          rescue StandardError => e
            transaction.destroy
            render json: { error: e.message }, status: :unprocessable_entity
          end
        else
          render json: { error: transaction.errors.full_messages.join(', ') }, status: :unprocessable_entity
        end
      end
      
      private
      
      def set_account
        @account = Account.find(params[:account_id])
      end
      
      def transaction_params
        params.require(:transaction).permit(:amount, :destiny_account_id)
      end
    end
  end
end
