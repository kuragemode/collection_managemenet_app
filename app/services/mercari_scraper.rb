class MercariScraper
  require 'selenium-webdriver'
  require 'nokogiri'

  def self.get_price(keyword)
    # 1. Chromeの設定 (Docker内で動くための特殊設定)
    options = Selenium::WebDriver::Chrome::Options.new
    options.add_argument('--headless') 
    options.add_argument('--no-sandbox')
    options.add_argument('--disable-dev-shm-usage')
    options.add_argument('--user-agent=Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36')

    driver = Selenium::WebDriver.for :chrome, options: options
    wait = Selenium::WebDriver::Wait.new(timeout: 10)

    begin
      url = "https://jp.mercari.com/search?keyword=#{URI.encode_www_form_component(keyword)}"
      puts "アクセス中: #{url}"
      driver.get(url)

      # 読み込み待機
      wait.until { driver.find_element(tag_name: 'body').displayed? }
      sleep 3

      # 解析
      doc = Nokogiri::HTML(driver.page_source)

      # 価格抽出ロジック (汎用版)
      prices = []
      doc.css('span').each do |span|
        text = span.text
        if text.match?(/¥|円/) && text.match?(/[0-9,]+/)
           price = text.gsub(/[^0-9]/, '').to_i
           prices << price if price > 100 
        end
      end

      # 平均価格算出
      return 0 if prices.empty?
      target_prices = prices.first(30)
      avg_price = target_prices.sum / target_prices.size
      
      puts "------------------------------------------------"
      puts "キーワード: #{keyword}"
      puts "取得件数: #{target_prices.size} 件"
      puts "平均価格: #{avg_price} 円"
      puts "------------------------------------------------"
      
      return avg_price

    rescue => e
      puts "エラー: #{e.message}"
    ensure
      driver.quit
    end
  end
end
