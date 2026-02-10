json.extract! item, :id, :name, :purchase_price, :current_market_price, :created_at, :updated_at
json.url item_url(item, format: :json)
