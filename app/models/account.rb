class Account < ApplicationRecord
  enum role: { admin: 'admin', user: 'user' }

  validates :first_name, presence: true, length: { maximum: 50 }
end
