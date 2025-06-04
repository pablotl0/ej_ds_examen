# app/models/user.rb
class User < ApplicationRecord
  has_many :accounts, dependent: :destroy
  
  validates :name, presence: true
end

