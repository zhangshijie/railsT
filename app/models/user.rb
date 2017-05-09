class User < ApplicationRecord
  # before_save { self.email = email.downcase }
  # before_save {email.downcase!}
  validates :name , presence: true , length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email , presence: true, length: { maximum: 255 },
                   format: {with: VALID_EMAIL_REGEX} , 
                   uniqueness: { case_sensitive: false}

  has_secure_password 
  validates :password, presence: true , length: {minimum: 6} , allow_nil: true

  attr_accessor :remember_token, :activation_token, :reset_token
  before_save :downcase_email
  before_create :create_activation_digest
  has_many :microposts, dependent: :destroy


  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def self.new_token
    SecureRandom.urlsafe_base64
  end

  #如果指定的令牌和摘要匹配， 返回true
  # def authenticated?(remember_token)
  #   return false if remember_digest.nil?
  #   BCrypt::Password.new(remember_digest).is_password?(remember_token)
  # end

  # 如果指定的令牌和摘要匹配，返回 true
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  def forget 
    update_attribute(:remember_digest, nil)
  end

  #激活用户
  def activate
    update_attribute(:activated, true)
    update_attribute(:activation_at, Time.zone.now)
  end

  #发送邮件
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  #设置密码重设相关的属性
  def create_reset_digest
    self.reset_token = User.new_token
    #更新摘要字段
    update_attribute(:reset_digest, User.digest(reset_token))
    #更新发送时间
    update_attribute(:reset_sent_at, Time.zone.now)
  end
  
  # 发送密码重设邮件
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  #当密码重的请求超时，返回true
  def password_reset_expired
    reset_sent_at < 2.hour.ago
  end
  private 
    #把电子邮件地址转换为小写
    def downcase_email
      self.email = email.downcase
    end

    #创建并赋值激活令牌和摘要
    def create_activation_digest
      self.activation_token = User.new_token
      self.activation_digest = User.digest(activation_token)
    end
end
