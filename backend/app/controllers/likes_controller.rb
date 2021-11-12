class LikesController < ApplicationController
  before_action :authenticate_member!

  def index
    @liked_posts = current_member.liked_posts
    render json: @liked_posts
  end

  def create
    current_member.likes.create!(post_id: params[:post_id])
    render json: :created
  end

  def destroy
    if current_member.is_a?(Band)
      like = Like.find_by(band: current_band, post_id: params[:post_id])
    else
      like = Like.find_by(audience: current_audience, post_id: params[:post_id])
    end
    like.destroy!
    render json: :ok
  end
end
