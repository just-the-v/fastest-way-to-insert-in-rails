class Mission < ApplicationRecord
  belongs_to :account
  has_many :tasks, dependent: :destroy
end
