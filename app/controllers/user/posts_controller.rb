class User::PostsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_post, only: [:edit, :update]
  
    def index
      @posts = current_user.posts
    end
  
    def edit
    end
  
    def update
      if @post.update(post_params)
        redirect_to user_posts_path, notice: 'Post was successfully updated.'
      else
        render :edit
      end
    end
  
    private
  
    def set_post
      @post = Post.find(params[:id])
    end
  
    def post_params
      params.require(:post).permit(:title, :content)
    end
  end
  