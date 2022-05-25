class LikesController < ApplicationController
  before_action :authenticate_member!

  def index
    @posts = current_member.liked_posts.newest
  end

  def create
    @like = current_member.likes.build(post_id: params[:post_id])
    if @like.save
      render json: :created
    else
      render json: :bad_request
    end
  end

  def destroy
    if current_member.is_a?(Band)
      @like = Like.find_by(band: current_band, post_id: params[:post_id])
    else
      @like = Like.find_by(audience: current_audience, post_id: params[:post_id])
    end
    if @like.destroy
      render json: :ok
    else
      render json: :bad_request
    end
  end
end
