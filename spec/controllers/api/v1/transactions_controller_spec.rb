require 'rails_helper'

RSpec.describe Api::V1::TransactionsController, type: :controller do
  let!(:user) { User.create(email: 'test@example.com', password: 'password') }
  let!(:target_wallet) { UserWallet.create(name: 'Target Wallet', balance: 100, walletable: user) }
  let!(:source_wallet) { UserWallet.create(name: 'Source Wallet', balance: 0, walletable: user) }

  before do
    # Simulate user login by setting the session
    request.session[:user_id] = user.id
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      let(:valid_attributes) do
        {
          transaction: {
            amount: 50,
            transaction_type: 'credit',
            target_wallet_id: target_wallet.id,
            source_wallet_id: nil
          }
        }
      end

      it 'creates a new transaction' do
        expect {
          post :create, params: valid_attributes
        }.to change(Transaction, :count).by(1)
      end

      it 'returns a success message' do
        post :create, params: valid_attributes
        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)['message']).to eq('Transaction successful')
      end

      it 'updates the target wallet balance' do
        post :create, params: valid_attributes
        expect(target_wallet.reload.balance.to_i).to eq(150) # Ensure to compare as integers
      end
    end

    context 'with invalid parameters' do
      let(:invalid_attributes) do
        {
          transaction: {
            amount: nil, # Invalid amount
            transaction_type: 'credit',
            target_wallet_id: target_wallet.id,
            source_wallet_id: nil
          }
        }
      end

      it 'does not create a new transaction' do
        expect {
          post :create, params: invalid_attributes
        }.to change(Transaction, :count).by(0)
      end

      it 'returns error messages' do
        post :create, params: invalid_attributes
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['errors']).to include("Amount can't be blank")
      end
    end
  end
end
