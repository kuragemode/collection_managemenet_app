class Item < ApplicationRecord
  belongs_to :user
  
  # ▼ これを追加（画像ファイルを1つ添付できる）
  has_one_attached :image

  # 保存する前に、もし市場価格が空なら自動で取得する（オプション）
  # before_create :refresh_market_price

  def refresh_market_price
    # スクレイパーを呼び出して価格を取得
    price = MercariScraper.get_price(self.name)
    
    if price
      # 取得できたらデータベースを更新
      update(current_market_price: price)
      puts "価格を更新しました: #{price}円"
    else
      puts "価格の取得に失敗しました"
    end
  end
end