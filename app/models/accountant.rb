class Accountant < ApplicationRecord
    has_many :customers
    has_many :accounts, through: :customers
end
