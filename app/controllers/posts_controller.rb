class PostsController < ApplicationController
  before_action :set_post, only: %i[ show edit update destroy ]
  before_action :set_meta, only: %i[ show ]

  NUMBER_PER_PAGE = 5

  # GET /posts or /posts.json
  def index
    @posts = Post.eager_load(:writer, :tags)
      .where("title LIKE '%#{params[:q]}%'")
      .order(created_at: :desc)
      .page(params[:page])
      .per(NUMBER_PER_PAGE)
  end

  # GET /posts/1 or /posts/1.json
  def show
    # PostView.create(post_id: @post.id)
    # change to job trigger

    CreatePostViewsJob.perform_later(post_id: @post.id)
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts or /posts.json
  def create
    @post = Post.new(post_params)

    respond_to do |format|
      if @post.save
        format.turbo_stream
        format.html { redirect_to post_url(@post), notice: "Post was successfully created." }
        format.json { render :show, status: :created, location: @post }
      else
        # binding.irb
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1 or /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.turbo_stream
        format.html { redirect_to post_url(@post), notice: "Post was successfully updated." }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1 or /posts/1.json
  def destroy
    @post.destroy!

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to posts_url, notice: "Post was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])

      # if stale?(@post)
    rescue ActiveRecord::RecordNotFound
      redirect_to root_path
      # render file: "#{Rails.root}/public/404.html", status: :not_found
    end

    def set_meta
      @meta = {
        title: @post.title
      }
    end

    # Only allow a list of trusted parameters through.
    def post_params
      # Strong parameters
      params.require(:post).permit(:title, :body, :writer_id, :tags_string)
    end
end
