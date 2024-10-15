class Wallet < ApplicationRecord
  belongs_to :walletable, polymorphic: true
  has_many :transactions_as_source, class_name: "Transaction", foreign_key: "source_wallet_id"
  has_many :transactions_as_target, class_name: "Transaction", foreign_key: "target_wallet_id"

  validates :name, :balance, presence: true

  def calculate_balance
    credits = transactions_as_target.where(transaction_type: "credit").sum(:amount)
    debits = transactions_as_source.where(transaction_type: "debit").sum(:amount)
    self.balance = credits - debits
    save
  end
end
