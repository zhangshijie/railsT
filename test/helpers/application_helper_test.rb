require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase

  test "full title helper" do
    assert_equal full_title, FILL_IN
    assert_equal full_title("Help"), FILL_IN
  end
end

class ActionDispatch::IntegrationTest

  #登入指定的用户
  def log_in_as (user, password: 'password', remember_me: '1')
    post login_path , params: {session: { email: user.email, password: password, remember_me: remember_me}}
  end
end