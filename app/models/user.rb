class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true

  has_many :recipes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :bookmarking_recipes, through: :bookmarks, source: :recipe

  has_one_attached :image
  def get_image
    if image.attached?
      image
    else
      ActiveStorage::Blob.create_and_upload!(io: File.open(Rails.root.join("app", "assets", "images", "no_image.jpg")), filename: "no_image.jpg")
    end
  end


  # そのレシピをユーザーがブックマークしているかどうか判断するメソッド
  def bookmarking?(recipe)
    bookmarking_recipes.include?(recipe)
  end
  # ゲストログイン用のメソッド
  def self.guest
    find_or_create_by!(email: "guest@example.com") do |user|
      user.password = SecureRandom.urlsafe_base64
      user.name = "ゲストユーザー"
    end
  end
end
