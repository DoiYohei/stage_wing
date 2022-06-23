class CommentsController < ApplicationController
  before_action :authenticate_member!

  def create
    comment = current_member.comments.build(comment_params)
    if comment.save
      head :created
    else
      head :unprocessable_entity
    end
  end

  def destroy
    comment = current_member.comments.find(params[:id])
    if comment.destroy
      head :ok
    else
      head :bad_request
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:event_id, :parent_id, :content)
  end
end
