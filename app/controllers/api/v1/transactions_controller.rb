# app/controllers/api/v1/transactions_controller.rb
class Api::V1::TransactionsController < ApplicationController
  def create
    ActiveRecord::Base.transaction do
      transaction = Transaction.new(transaction_params)

      if transaction.save
        render json: { message: "Transaction successful", transaction: transaction }, status: :created
      else
        Rails.logger.debug "Transaction errors: #{transaction.errors.full_messages.join(', ')}" # Add this line
        render json: { errors: transaction.errors.full_messages }, status: :unprocessable_entity
      end
    end
  end

  private

  def transaction_params
    params.require(:transaction).permit(:amount, :transaction_type, :source_wallet_id, :target_wallet_id)
  end
end
