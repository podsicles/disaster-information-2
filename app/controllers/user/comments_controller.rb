class User::CommentsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_comment, only: [:edit, :update]
  
    def index
      @comments = current_user.comments
    end
  
    def edit
    end
  
    def update
      if @comment.update(comment_params)
        redirect_to user_comments_path, notice: 'Comment was successfully updated.'
      else
        render :edit
      end
    end
  
    private
  
    def set_comment
      @comment = Comment.find(params[:id])
    end
  
    def comment_params
      params.require(:comment).permit(:content)
    end
end