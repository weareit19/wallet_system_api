# app/controllers/api/v1/stocks_controller.rb
class Api::V1::StocksController < ApplicationController
  before_action :require_login
  def price
    symbol = params[:symbol]
    stock_price_service = LatestStockPrice.new
    result = stock_price_service.latest_price(symbol)
    render json: result
      rescue => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  def prices
    symbols = params[:symbols] # Expecting comma-separated symbols in the query string
    stock_price_service = LatestStockPrice.new
    result = stock_price_service.latest_prices(symbols.split(","))
    render json: result
      rescue => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  def price_all
    stock_price_service = LatestStockPrice.new
    result = stock_price_service.price_all
    render json: result
      rescue => e
    render json: { error: e.message }, status: :unprocessable_entity
  end
end
