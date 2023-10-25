class Account < ApplicationRecord
  enum role: { admin: 'admin', user: 'user' }
end
