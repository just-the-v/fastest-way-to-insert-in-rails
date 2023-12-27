class Account < ApplicationRecord
  has_many :missions, dependent: :destroy
  has_many :tasks, through: :missions

  enum role: { admin: 'admin', user: 'user' }

  validates :first_name, presence: true, length: { maximum: 50 }
end
