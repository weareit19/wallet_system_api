require "httparty"
require "json"

class LatestStockPrice
  BASE_URL = "https://latest-stock-price8.p.rapidapi.com/"
  URL = "https://latest-stock-price.p.rapidapi.com/any"

  def initialize(api_key = nil)
    @api_key = api_key || ENV["RAPIDAPI_KEY"]
    raise "RAPIDAPI_KEY is missing" unless @api_key

    @headers = {
      "X-RapidAPI-Key" => @api_key,
      "X-RapidAPI-Host" => "latest-stock-price.p.rapidapi.com"  # Correct host
    }
  end

  def latest_price(symbol)
    url = "#{BASE_URL}"
    response = HTTParty.get(url, headers: @headers)
    parse_response(response)
  end

  def latest_prices(symbols)
    symbols_query = symbols.join(",")
    endpoint = "/prices?Symbols=#{symbols_query}"  # Using '/prices' endpoint for multiple symbols
    response = request(endpoint)
    parse_response(response)
  end

  def price_all
    response = request(URL)
    parse_response(response)
  end

  private

  def request(endpoint)
    url = "#{URL}"
    puts "Requesting URL: #{url}"  # Debugging line to see the full URL
    HTTParty.get(url, headers: @headers)
  end

  def parse_response(response)
    if response.success?
      JSON.parse(response.body)
    else
      handle_error(response)
    end
  rescue JSON::ParserError
    raise "Invalid response format"
  end

  def handle_error(response)
    error_message = "Error: #{response.code} - #{response.message}"
    raise error_message
  end
end
