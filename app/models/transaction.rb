# app/models/transaction.rb
class Transaction < ApplicationRecord
  # Utilizamos el ID como string para mantener compatibilidad con el frontend
  self.primary_key = 'id'
  
  # Tipos de transacción
  DEPOSIT = 'deposit'
  WITHDRAWAL = 'withdrawal'
  TRANSFER = 'transfer'
  
  validates :id, presence: true, uniqueness: true
  validates :transaction_type, presence: true, inclusion: { in: [DEPOSIT, WITHDRAWAL, TRANSFER] }
  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :origin_account, presence: true
  validates :destiny_account, presence: true, if: -> { transaction_type == TRANSFER }
  
  # Método para aplicar la transacción en las cuentas correspondientes
  def apply
    case transaction_type
    when DEPOSIT
      apply_deposit
    when WITHDRAWAL
      apply_withdrawal
    when TRANSFER
      apply_transfer
    end
  end
  
  # Métodos para generar una representación string de la transacción
  def to_s
    case transaction_type
    when DEPOSIT
      "Deposit of #{amount}"
    when WITHDRAWAL
      "Withdrawal of #{amount}"
    when TRANSFER
      "Transfer of #{amount} to #{destiny_account}"
    end
  end
  
  private
  
  def apply_deposit
    origin = Account.find_by(id: origin_account)
    raise "Account not found" unless origin
    
    origin.deposit(amount) || raise("Error depositing money")
  end
  
  def apply_withdrawal
    origin = Account.find_by(id: origin_account)
    raise "Account not found" unless origin
    
    origin.withdrawal(amount) || raise("Error withdrawing money")
  end
  
  def apply_transfer
    origin = Account.find_by(id: origin_account)
    destiny = Account.find_by(id: destiny_account)
    
    raise "Origin account not found" unless origin
    raise "Destiny account not found" unless destiny
    
    if origin.withdrawal(amount)
      unless destiny.deposit(amount)
        origin.deposit(amount)
        raise "Error depositing money to destination account"
      end
    else
      raise "Error transferring money"
    end
  end
end
