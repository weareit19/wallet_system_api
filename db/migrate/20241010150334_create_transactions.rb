class CreateTransactions < ActiveRecord::Migration[7.2]
  def change
    create_table :transactions do |t|
      t.references :source_wallet, foreign_key: { to_table: :wallets }, index: true
      t.references :target_wallet, foreign_key: { to_table: :wallets }, index: true
      t.decimal :amount, precision: 10, scale: 2, null: false
      t.string :transaction_type, null: false # Credit or Debit
      t.string :status, default: 'pending'

      t.timestamps
    end
  end
end
