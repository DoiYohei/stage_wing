class CommentsController < ApplicationController
  before_action :authenticate_member!

  def create
    comment = current_member.comments.build(comment_params)
    if comment.save
      render json: :created
    else
      render json: :unprocessable_entity
    end
  end

  def destroy
    comment = current_member.comments.find(params[:id])
    if comment.destroy
      render json: :ok
    else
      render json: :bad_request
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:event_id, :parent_id, :content)
  end
end
