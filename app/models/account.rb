# app/models/account.rb
class Account < ApplicationRecord
  belongs_to :user
  
  # Utilizamos el ID como string para mantener compatibilidad con el frontend
  self.primary_key = 'id'
  
  # Transacciones asociadas a esta cuenta (origen o destino)
  has_many :origin_transactions, -> { where("origin_account = ?", id) }, class_name: 'Transaction', foreign_key: 'origin_account', primary_key: 'id', dependent: :destroy
  has_many :destiny_transactions, -> { where("destiny_account = ?", id) }, class_name: 'Transaction', foreign_key: 'destiny_account', primary_key: 'id', dependent: :destroy
  
  validates :id, presence: true, uniqueness: true
  validates :amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
  
  # Métodos correspondientes a la lógica del código Flutter
  def deposit(amount)
    return false if amount <= 0
    
    self.amount += amount
    save
    true
  end
  
  def withdrawal(amount)
    return false if amount <= 0 || self.amount - amount < 0
    
    self.amount -= amount
    save
    true
  end
  
  # Método para obtener todas las transacciones (origen y destino)
  def all_transactions
    Transaction.where("origin_account = ? OR destiny_account = ?", id, id)
                .order(created_at: :desc)
  end
end
