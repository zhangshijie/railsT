require 'test_helper'

class MicropostTest < ActiveSupport::TestCase
  def setup
    @user = users(:michael)
    # @micropost = Micropost.new(content:'abc', user_id: @user.id)
    @micropost = @user.microposts.build(content: "abc")
  end

  test "should be valid" do
    assert @micropost.valid?
  end

  test "user id shoud be present" do
    @micropost.user_id = nil
    assert_not @micropost.valid?
  end

  test "content should be present" do
    @micropost.content = nil
    assert_not @micropost.valid?
  end

  test "content should be at most 140 characters" do
    @micropost.content = 'a' * 141
    assert_not @micropost.valid?
  end

  test "order should be most recent first" do
    assert_equal microposts(:most_recent) , Micropost.first
  end
end
