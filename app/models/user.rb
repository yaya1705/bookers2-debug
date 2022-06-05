class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy
  
  
  has_many :relationships, foreign_key: :following_id
  # フォローする側から中間テーブルへのアソシエーション
  has_many :followings, through: :relationships, source: :follower
  # フォローする側からフォローされたユーザを取得する
  
  has_many :reverse_of_relationships, class_name: 'Relationship', foreign_key: :follower_id
  # フォローされる側から中間テーブルへのアソシエーション
  has_many :followers, through: :reverse_of_relationships, source: :following
  # フォローされる側からフォローしているユーザを取得する
  
  
  def following?(user)
    followings.include?(user)
    # フォロワー=followings、(user) = 1人のユーザー、includde? = 含まれているか？
  end
  
  def self.search_for(content,method)
    if method == "perfect"
      User.where(name: content)
    elsif method == "forward"
      User.where("name LIKE?", content + "%")
    elsif method == "backward"
      @user = User.where("name LIKE?", "%" + content)
    else
      User.where("name LIKE ?", "%"+ content + "%")
    end
  end
  
  has_one_attached :profile_image

  validates :name, length: { minimum: 2, maximum: 20 }, uniqueness: true
  validates :introduction, length: {maximum: 50} 

  def get_profile_image(width, height)
    unless profile_image.attached?
      file_path = Rails.root.join('app/assets/images/sample-author1.jpg')
      profile_image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    profile_image.variant(resize_to_limit: [width, height]).processed
  end

end
