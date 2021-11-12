class CommentsController < ApplicationController
  before_action :authenticate_member!

  def create
    comment = current_member.comments.build(comment_params)
    if comment.save
      render json: :created
    else
      render json: comment.errors, status: :unprocessable_entity
    end
  end

  def destroy
    comment = current_member.comments.find(params[:id])
    comment.destroy!
    render json: :ok
  end

  private

  def comment_params
    params.require(:comment).permit(:event_id, :parent_id, :content)
  end
end
