# spec/models/wallet_spec.rb

require 'rails_helper'

RSpec.describe Wallet, type: :model do
  it 'is valid with valid attributes' do
    user = User.create(email: 'test@example.com', password: 'password')
    wallet = Wallet.new(name: 'Test Wallet', balance: 100, walletable: user)
    expect(wallet).to be_valid
  end

  it 'is not valid without a name' do
    user = User.create(email: 'test@example.com', password: 'password')
    wallet = Wallet.new(name: nil, balance: 100, walletable: user)
    expect(wallet).to_not be_valid
  end

  it 'is not valid without a balance' do
    user = User.create(email: 'test@example.com', password: 'password')
    wallet = Wallet.new(name: 'Test Wallet', balance: nil, walletable: user)
    expect(wallet).to_not be_valid
  end

  describe '#calculate_balance' do
    it 'calculates the balance based on transactions' do
      user = User.create(email: 'test@example.com', password: 'password')
      wallet = UserWallet.create(name: 'Test Wallet', balance: 0, walletable: user)

      # Create transactions
      Transaction.create(amount: 100, transaction_type: 'credit', target_wallet: wallet)
      Transaction.create(amount: 50, transaction_type: 'debit', source_wallet: wallet)

      wallet.calculate_balance

      expect(wallet.balance).to eq(50)  # 100 - 50 = 50
    end
  end
end
