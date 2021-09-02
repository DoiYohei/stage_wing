class LikesController < ApplicationController
  def create
    current_band.likes.create!(post_id: params[:post_id])
    render json: :created
  end

  def destroy
    like = Like.find_by(band: current_band.id, post_id: params[:post_id])
    like.destroy!
    render json: :ok
  end
end
