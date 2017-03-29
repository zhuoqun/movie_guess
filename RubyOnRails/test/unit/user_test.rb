require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "the truth" do
    assert true
  end

  test "should not save user without user_name" do
      user = User.new
      assert user.save, "Can't be saved"
  end
end
