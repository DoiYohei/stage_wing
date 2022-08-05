class LikesController < ApplicationController
  before_action :authenticate_member!

  def index
    @posts = current_member.liked_posts.newest
  end

  def create
    post = Post.find(params[:post_id])
    like = current_member.likes.build(post_id: post.id)
    if like.save
      head :created
    else
      head :bad_request
    end
  end

  def destroy
    like = current_member.likes.find_by!(post_id: params[:post_id])
    if like.destroy
      head :ok
    else
      head :bad_request
    end
  end
end
