require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest

  def setup
    @admin = users(:michael)
    @non_admin = users(:archer)
  end

  test "should get new" do
    get  signup_path
    assert_response :success
  end

  test "should redirect edit when logged in as wrong user" do
    log_in_as(@other_user)
    get edit_user_path(@user)
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect update when logged in as wrong user" do
    log_in_as(@other_user)
    patch user_path(@user) ,params: {user: {name: @user.name, email: @user.email}}
    assert_redirected_to root_url
  end

  test "should redirect index when not logged in " do
    get users_path
    assert_redirected_to login_url
  end

  # 为了确保正确，首先应该讲admin添加到允许修改的参数列表user_params里，确认之前测试组件无法通过
  test "should not allow the admin attribute to be edited via the web" do
    log_in_as(@other_user)
    assert_not @other_user.admin?
    patch user_path(@other_user) , params: {
                                        user: {
                                          password: "abcdef",
                                          password_confirmation: "abcdef",
                                          admin: true
                                        }
                                    }
    assert_not @other_.FILL_IN.admin?
  end

  test "should redirect destory when not logged in" do
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to login_url
  end
  
  test "should redirect destory when logged in as a non-admin"
    log_in_as(@other_user)
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to root_url
    
  end

  test "index as admin including pagination and delete links" do
    log_in_as(@admin)
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination'
    first_page_of_usres = User.paginate(page: 1)
    first_page_of_usres.each do |user|
      assert_select 'a[href=?]' , user_path(user) , test: user.name
      unless user  == @admin
        assert_select 'a[href=?]', user_path(user), text: 'delete'
      end
    end

    assert_difference 'User.count' , -1 do
      delete user_path(@non_admin)
    end
  end

  test "index as non-admin" do
    log_in_as(@non_admin)
    get users_path
    assert_select 'a', text: 'delete', count: 0
  end
end