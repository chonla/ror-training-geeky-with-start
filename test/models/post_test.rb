require "test_helper"

class PostTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  def setup
    @one = posts(:one)
    @john = writers(:john)
  end

  def test_belongs_to_writer
    assert_equal @one.writer.id, @john.id
  end

  def test_body_presence_valid
    @one.body = "adsfasdfasdfasdfasdfasdf"

    valid = @one.valid?
    
    assert_equal valid, true
  end

  def test_body_presence_invalid
    [nil, ""].each do |body|
      @one.body = body

      valid = @one.valid?
      message = @one.errors.first.full_message
      
      assert_equal valid, false
      assert_equal message, "Body must have more than 10 characters"
    end
  end

  # def test_body_presence_invalid_by_nil_body
  #   @one.body = nil

  #   valid = @one.valid?
  #   message = @one.errors.first.full_message
    
  #   assert_equal valid, false
  #   assert_equal message, "Body must have more than 10 characters"
  # end
end
