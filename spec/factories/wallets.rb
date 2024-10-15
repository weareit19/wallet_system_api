FactoryBot.define do
  factory :wallet do
    name { "My Wallet" }

    association :walletable, factory: :user  # or any valid model that `walletable` refers to
  end
end
