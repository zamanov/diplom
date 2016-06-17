class PostsController < ApplicationController

  # GET /posts
  def index
    if params[:search]
      @posts = Post.search(params[:search]).ordering.includes(:person, :placeable).page(params[:page])
    else
      @posts = Post.ordering.includes(:person, :placeable).page(params[:page])
    end
    if params[:university]
      if params[:is_manage]
        @posts = @posts.where(:placeable_type => 'University', :placeable_id => params[:university], :is_manage => params[:is_manage])
      else
        @posts = @posts.where(:placeable_type => 'University', :placeable_id => params[:university])
      end
    end
  end

  # GET /posts/1
  def show
    @post = Post.find(params[:id])
  end
end
