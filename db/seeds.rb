# db/seeds.rb
# Crear un usuario de ejemplo
user = User.create!(name: 'ejemplo')

# Crear una cuenta para el usuario
account = user.accounts.create!(id: "ejemplo-0", amount: 1000)

# Crear algunas transacciones
# Depósito
deposit = Transaction.create!(
  id: "ejemplo-0-500",
  transaction_type: Transaction::DEPOSIT,
  amount: 500,
  origin_account: account.id,
  destiny_account: account.id
)
deposit.apply

# Retiro
withdrawal = Transaction.create!(
  id: "ejemplo-1-200",
  transaction_type: Transaction::WITHDRAWAL,
  amount: 200,
  origin_account: account.id,
  destiny_account: account.id
)
withdrawal.apply

# Crear una segunda cuenta
account2 = user.accounts.create!(id: "ejemplo-1", amount: 0)

# Transferencia
transfer = Transaction.create!(
  id: "ejemplo-2-300",
  transaction_type: Transaction::TRANSFER,
  amount: 300,
  origin_account: account.id,
  destiny_account: account2.id
)
transfer.apply

puts "Seed data created successfully!"
