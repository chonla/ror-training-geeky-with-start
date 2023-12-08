require "test_helper"

class WriterTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  def setup
    @writer = writers(:john)
  end

  def test_count
    assert_equal Writer.count, 2
  end

  def test_name
    assert_equal @writer.name, "John"
  end
end
