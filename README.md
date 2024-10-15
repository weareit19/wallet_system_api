
# Wallet & Transaction System

### Overview    

This project implements a generic wallet solution for handling money transactions (credits and debits) between various entities (like User, Team, Stock, or other models). It ensures proper management of wallet balances and secure transaction processing, following the ACID standards. Additionally, a custom sign-in solution and a LatestStockPrice library for fetching stock prices are provided.    

## Tasks Implemented    
### Generic Wallet Architecture
Created a generic wallet system that allows money manipulation between entities such as User, Stock, Team, and others.

### Model Relationships and Validations     
Created model relationships for entities and transactions:

#### Wallet:   
Represents a money-holding entity (for User, Stock, Team, etc.) using STI.

#### Transaction:   
Handles the movement of money between wallets, ensuring each transaction is valid with respect to its source and target.    

#### Validations ensure:     
Credits do not have a `source_wallet`.   
Debits do not have a `target_wallet`.    
Required fields like `amount` and `transaction_type` are present.     

### Single Table Inheritance (STI)    
Used STI for wallets, enabling different types of wallets (e.g., `UserWallet`, `TeamWallet`, `StockWallet`) to inherit from a single Wallet model, while supporting custom logic specific to each wallet type if needed.    

### LatestStockPrice Library    
Created a LatestStockPrice library in the lib folder for fetching stock prices from the Latest Stock Price API.     

#### This library provides three endpoints:   
`price:` Fetches the price of a specific stock.   
`prices:` Fetches prices of multiple stocks.   
`price_all:` Fetches all available stock prices.  


## Setup Instructions     
git clone:  `https://github.com/shimroz1992/wallet_system_api.git`    

cd `wallet_system_api`     

#### Install Dependencies     

Ruby: `3.2.0`    
rails: `7.2.1`

Make sure you have Rails and PostgreSQL installed, then run:    
`bundle install`    

#### Database Setup   

`rails db:create`   
`rails db:migrate`

### Create Sample Data     
To test the wallet and transaction system, you can create a User, their Wallet, and make some transactions.   

#### Create a user
`user = User.create(email: "user@example.com", password: "password123")`

#### Create a wallet for the user     

`user_wallet = UserWallet.create(walletable: user, name: "Main Wallet", balance: 1000)`     

#### Create a credit transaction (add money to the wallet)     

`Transaction.create(target_wallet: user_wallet, amount: 100, transaction_type: "credit")`      

#### Create a debit transaction (subtract money from the wallet)     

`Transaction.create(source_wallet: user_wallet, amount: 50, transaction_type: "debit")`     

#### Check the updated balance    

`user_wallet.reload.balance`      

### Testing with RSpec     

This project uses RSpec for unit testing. To get started with RSpec, follow the steps below:     

#### Install RSpec     
Add RSpec to your Gemfile: `gem 'rspec-rails', '~> 5.0'`     

Then, run:    
`bundle install`    
`rails generate rspec:install`    


This will set up the RSpec configuration and create the necessary spec directories.     

#### Run the Specs    
 `rspec`

## Conclusion
This project implements a flexible wallet system for secure transactions, custom sign-in, and a stock price library, ideal for financial applications.
