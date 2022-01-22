class PostsController < ApplicationController
  before_action :authenticate_band!
  before_action :set_post, only: %i(update destroy)
  
  def create
    @post = current_band.posts.build(post_params)
    if @post.save
      render json: :created
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  def update
    if @post.update(post_params)
      render json: :ok
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @post.destroy!
    render json: :ok
  end

  private

  def post_params
    params.require(:post).permit(:format, :photo, :audio, :media_pass, :description)
  end

  def set_post
    @post = current_band.posts.find(params[:id])
  end
end
