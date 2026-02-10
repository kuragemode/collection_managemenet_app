class User < ApplicationRecord
  # Deviseの設定
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # ▼ これを追加（ユーザーが消えたら、アイテムも道連れに削除する設定）
  has_many :items, dependent: :destroy
end