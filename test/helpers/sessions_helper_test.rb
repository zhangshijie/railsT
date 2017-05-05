require 'test_helper'

class SessionsHelperTest < ActionView::TestCase

  def setup
    @user = users(:michael)
    remember(@user)
  end
  #在 Sessions 辅助模块的测试中直接 测试 current_user 方法# 
   # 1. 使用固件定义一个user变量;
   # 2. 调用remember方法记住这个用户; 
   # 3. 确认current_user就是这个用户。
  test "current_user returns right user when session is nil " do
    assert_equal @user, current_user
    assert is_logged_in?
  end

  test "current_user returns nil when remember digest is wrong" do
    @user.update_attribute(:remember_digest, User.digest(User.new_token))
    assert_nil current_user
  end
end