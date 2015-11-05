require 'util'

class UtilTest < Minitest::Test
  def test_conversion
    assert_equal conversion('58d4d929aeeafa40cc049f032035784fb085e8e0d0c5a51ea067341a93d6d286'), 'WNTZKa7q+kDMBJ8DIDV4T7CF6ODQxaUeoGc0GpPW0oY'
  end
end
