class LikesController < ApplicationController
  before_action :autheticate_member!

  def create
    current_member.likes.create!(post_id: params[:post_id])
    render json: :created
  end

  def destroy
    like = Like.find_by(member: current_member, post_id: params[:post_id])
    like.destroy!
    render json: :ok
  end
end
