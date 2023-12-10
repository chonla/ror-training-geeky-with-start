class Post < ApplicationRecord
  include ContentEditable

  belongs_to :writer, counter_cache: true
  # post count is now cache with counter_cache
  # addressable by posts_count
  # custom posts_count -> couter_cache: :posts_count
  # migration is required
  # bundle exec rails g migration AddPostsCountToWriters posts_count:integer
  # bundle exec rails db:migrate
  # NAME MATTERS!! rails tries to understand migration and create script for you!!
  # Writer.reset_counters(id, :posts_count) -> to reset counters for given id

  has_many :post_tags, dependent: :destroy
  has_many :tags, through: :post_tags
  has_many :views, class_name: "PostView"

  # validates :body, presence: true

  # after_initialize :assign_default_titte

  # def assign_default_titte
  #   self.title = 'untitled'
  # end

  # before_save
  # before_create
  # before_update
  # after_save
  # after_create
  # after_update

  # before_save :prepend_title

  # def prepend_title
  #   self.title = "Saved: #{title}"
  # end

  # def initialize(params={})
  #   super()
  # end

  after_create_commit :broadcast_prepend_to_post

  def broadcast_prepend_to_post
    broadcast_prepend_to(
      "posts_list",
      partial: "posts/post_row",
      locals: {
        post: self
      },
      target: "posts_result"
    )
  end

  def writer_name
    writer.name
  end

  def tags_string
    tags.pluck(:name).join(", ")
  end

  def tags_string=(value)
    # value example = "game, movie"
    words = value.split(",").map{|s| s.strip.downcase}

    tags.delete_all

    words.uniq.each do |word|
      tag = Tag.find_or_create_by(name: word)

      tags << tag
    end
  end
end
