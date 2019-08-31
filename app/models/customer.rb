class Customer < ApplicationRecord
    has_many :accounts, dependent: :destroy
    belongs_to :accountant
end
