class CreateWallets < ActiveRecord::Migration[7.2]
  def change
    create_table :wallets do |t|
      t.string :name, null: false
      t.references :walletable, polymorphic: true, index: true
      t.decimal :balance, precision: 10, scale: 2, default: 0.0
      t.string :type # For STI (Single Table Inheritance)

      t.timestamps
    end
  end
end
