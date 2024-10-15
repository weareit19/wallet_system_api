class Transaction < ApplicationRecord
  belongs_to :source_wallet, class_name: "Wallet", optional: true
  belongs_to :target_wallet, class_name: "Wallet", optional: true

  validates :amount, :transaction_type, presence: true
  validate :valid_wallets

  after_create :process_transaction

  private

  def valid_wallets
    if transaction_type == "credit" && source_wallet.present?
      errors.add(:source_wallet, "must be nil for credit transactions")
    elsif transaction_type == "debit" && target_wallet.present?
      errors.add(:target_wallet, "must be nil for debit transactions")
    end
  end

  def process_transaction
    if transaction_type == "credit"
      target_wallet.update!(balance: target_wallet.balance + amount)
    elsif transaction_type == "debit"
      source_wallet.update!(balance: source_wallet.balance - amount)
    end
  end
end
