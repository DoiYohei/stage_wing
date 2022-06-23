class PostsController < ApplicationController
  before_action :authenticate_band!
  before_action :set_post, only: %i(update destroy)
  
  def create
    @post = current_band.posts.build(post_params)
    if @post.save
      head :created
    else
      head :unprocessable_entity
    end
  end

  def update
    if @post.update(post_params)
      head :ok
    else
      head :unprocessable_entity
    end
  end

  def destroy
    if @post.destroy
      head :ok
    else
      head :bad_request
    end
  end

  private

  def post_params
    params.require(:post).permit(:format, :photo, :audio, :media_pass, :description)
  end

  def set_post
    @post = current_band.posts.find(params[:id])
  end
end
