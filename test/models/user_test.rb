require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name:"Example User",email:"user.example.com",
                     password:"foobar",password_confirmation:"foobar")
  end

  test "shoule be valid" do 
    assert @user.valid?
  end
  
  test "name shoule be present" do 
    @user.name = "    "
    assert_not @user.valid?
  end

  test "email shoule be present" do 
    @user.email = "    "
    assert_not @user.valid?
  end


  test "name shoule not  be too long" do 
    @user.name = "a" * 51
    assert_not @user.valid?
  end

  test "email shoule not  be too long" do 
    @user.name = "a" * 244 + "example.com" 
    assert_not @user.valid?
  end

  test "email address shoule be unique" do 
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end

  # test "email address should be saved as lower-case" do
  #   mixed_case_email = "Foo@ExAMPle.CoM"
  #   @user.email = mixed_case_email
  #   @user.save
  #   assert_equal mixed_case_email.downcase, @user.reload.email
  # end

  test "password should be present (nonblank) " do
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end

  test "password should have a minimum length " do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end

  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?('')
  end

end

