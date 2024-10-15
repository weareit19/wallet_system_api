# spec/models/transaction_spec.rb

require 'rails_helper'

RSpec.describe Transaction, type: :model do
  let(:user) { User.create(email: 'test@example.com', password: 'password') }
  let(:wallet) { UserWallet.create(name: 'Test Wallet', balance: 100, walletable: user) }

  it 'is valid with valid attributes for credit' do
    transaction = Transaction.new(amount: 100, transaction_type: 'credit', target_wallet: wallet)
    expect(transaction).to be_valid
  end

  it 'is valid with valid attributes for debit' do
    transaction = Transaction.new(amount: 50, transaction_type: 'debit', source_wallet: wallet)
    expect(transaction).to be_valid
  end

  it 'is not valid without an amount' do
    transaction = Transaction.new(amount: nil, transaction_type: 'credit', target_wallet: wallet)
    expect(transaction).to_not be_valid
  end

  it 'is not valid without a transaction type' do
    transaction = Transaction.new(amount: 100, transaction_type: nil, target_wallet: wallet)
    expect(transaction).to_not be_valid
  end

  it 'is not valid if source_wallet is present for credit transactions' do
    transaction = Transaction.new(amount: 100, transaction_type: 'credit', source_wallet: wallet)
    expect(transaction).to_not be_valid
  end

  it 'is not valid if target_wallet is present for debit transactions' do
    transaction = Transaction.new(amount: 50, transaction_type: 'debit', target_wallet: wallet)
    expect(transaction).to_not be_valid
  end

  describe '#process_transaction' do
    it 'updates the target wallet balance for credit transactions' do
      transaction = Transaction.create!(amount: 100, transaction_type: 'credit', target_wallet: wallet)
      expect(wallet.reload.balance).to eq(200)  # Initial balance 100 + credit 100
    end

    it 'updates the source wallet balance for debit transactions' do
      transaction = Transaction.create!(amount: 50, transaction_type: 'debit', source_wallet: wallet)
      expect(wallet.reload.balance).to eq(50)  # Initial balance 100 - debit 50
    end
  end
end
