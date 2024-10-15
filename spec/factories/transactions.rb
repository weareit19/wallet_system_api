FactoryBot.define do
  factory :transaction do
    amount { 100.00 }
    transaction_type { "transfer" }
    association :source_wallet, factory: :wallet
    association :target_wallet, factory: :wallet
  end
end
