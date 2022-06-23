class LikesController < ApplicationController
  before_action :authenticate_member!
  before_action :set_post, except: :index

  def index
    @posts = current_member.liked_posts.newest
  end

  def create
    like = current_member.likes.build(post_id: @post.id)
    if like.save
      head :created
    else
      head :bad_request
    end
  end

  def destroy
    if current_member.is_a?(Band)
      like = Like.find_by!(band: current_band, post_id: @post.id)
    else
      like = Like.find_by!(audience: current_audience, post_id: @post.id)
    end
    if like.destroy
      head :ok
    else
      head :bad_request
    end
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end
end
