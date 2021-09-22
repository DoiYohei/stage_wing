class CommentsController < ApplicationController
  def create
    comment = current_band.comments.build(comment_params)
    if comment.save
      render json: :created
    else
      render json: comment.errors, status: :unprocessable_entity
    end
  end

  def destroy
    comment = current_band.comments.find(params[:id])
    comment.destroy!
    render json: :ok
  end

  private

  def comment_params
    params.require(:comment).permit(:event_id, :parent_id, :content)
  end
end
