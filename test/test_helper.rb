ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'minitest/reporters'
Minitest::Reporters.use!

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all
  include ApplicationHelper

  #在测试中定义检查登陆状态的方法，返回布尔值
  #为啥要在这里定义这个方法
  def is_logged_in?
    !session[:user_id].nil?
  end
  
end
