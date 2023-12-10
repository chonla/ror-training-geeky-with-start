class CreatePostViewsJob < ApplicationJob
  queue_as :low

  def perform(post_id:)
    # Do something later
    post = Post.find(post_id)

    post.views.create
  end
end
