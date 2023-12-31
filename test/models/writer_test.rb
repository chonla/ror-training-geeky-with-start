require "test_helper"

class WriterTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  def setup
    @john = writers(:john)
    @junior = writers(:junior)
  end

  def test_count
    assert_equal Writer.count, 2
  end

  def test_name
    assert_equal @john.name, "John"
  end

  def test_has_many_posts
    assert_equal @john.posts.count, 1
  end

  def test_select_lists
    list = [["John", @john.id], ["Junior", @junior.id]].sort_by{|name, id| id}
    assert_equal Writer.select_lists, list
  end

  def test_unique_name
    writer = Writer.new(name: "John")

    assert_equal writer.valid?, false
  end
end
