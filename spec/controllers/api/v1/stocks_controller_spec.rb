# spec/controllers/api/v1/stocks_controller_spec.rb
require 'rails_helper'

RSpec.describe Api::V1::StocksController, type: :controller do
  let(:user) { User.create(email: "test@example.com", password: "password") }
  let(:latest_stock_price) { instance_double(LatestStockPrice) }

  before do
    allow(LatestStockPrice).to receive(:new).and_return(latest_stock_price)
    session[:user_id] = user.id # Simulate user login
  end

  describe "GET #price" do
    context "when valid symbol is provided" do
      let(:symbol) { 'AAPL' }
      let(:expected_response) { { symbol: 'AAPL', price: 150.0 } }

      it "returns the latest stock price" do
        allow(latest_stock_price).to receive(:latest_price).with(symbol).and_return(expected_response)

        get :price, params: { symbol: symbol }

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to eq(expected_response.stringify_keys)
      end
    end

    context "when an error occurs" do
      let(:symbol) { 'INVALID' }

      it "returns an error message" do
        allow(latest_stock_price).to receive(:latest_price).with(symbol).and_raise(StandardError.new("Stock not found"))

        get :price, params: { symbol: symbol }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to eq({ "error" => "Stock not found" })
      end
    end
  end

  describe "GET #prices" do
    context "when valid symbols are provided" do
      let(:symbols) { 'AAPL,GOOGL' }
      let(:expected_response) { [ { symbol: 'AAPL', price: 150.0 }, { symbol: 'GOOGL', price: 2800.0 } ] }

      it "returns the latest stock prices for multiple symbols" do
        allow(latest_stock_price).to receive(:latest_prices).with([ 'AAPL', 'GOOGL' ]).and_return(expected_response)

        get :prices, params: { symbols: symbols }

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to eq(expected_response.map(&:stringify_keys))
      end
    end

    context "when an error occurs" do
      let(:symbols) { 'INVALID' }

      it "returns an error message" do
        allow(latest_stock_price).to receive(:latest_prices).with([ 'INVALID' ]).and_raise(StandardError.new("Invalid symbols"))

        get :prices, params: { symbols: symbols }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to eq({ "error" => "Invalid symbols" })
      end
    end
  end

  describe "GET #price_all" do
    context "when it successfully fetches all prices" do
      let(:expected_response) { [ { symbol: 'AAPL', price: 150.0 }, { symbol: 'GOOGL', price: 2800.0 } ] }

      it "returns the latest prices for all stocks" do
        allow(latest_stock_price).to receive(:price_all).and_return(expected_response)

        get :price_all

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to eq(expected_response.map(&:stringify_keys))
      end
    end

    context "when an error occurs" do
      it "returns an error message" do
        allow(latest_stock_price).to receive(:price_all).and_raise(StandardError.new("Service unavailable"))

        get :price_all

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to eq({ "error" => "Service unavailable" })
      end
    end
  end
end
