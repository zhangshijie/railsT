class Micropost < ApplicationRecord
  belongs_to :user
  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: 140}
  default_scope -> { order(created_at: :desc)}
  validate :picture_size
  mount_uploader :picture, PictureUploader


  private
  
    # 验证上传的图像大小
    def picture_size
      if picture.size > 5.megabytes
        error.add(:picture, "should be less than 5MB")
      end
    end
end
