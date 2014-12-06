class PostsController < ApplicationController
  def create
    @post = Post.new post_params

    if @post.save
      PostedBy.create(from_node: @post, to_node: current_user)
      flash[:success] = 'Благодарим вас за публикацию статьи.'
      redirect_to @post
    else
      flash[:danger] = 'Исправьте ошибки.'
      render :edit
    end
  end

  def update
    @post = Post.find params[:id]

    if @post.update_attributes(post_params)
      flash[:success] = 'Статья изменена.'
      redirect_to @post
    else
      flash[:danger] = 'Исправьте ошибки.'
      render :edit
    end
  end

  def new
    @post = Post.new
  end

  def edit
    @post = Post.find params[:id]
  end

  def index
    @user = User.find(params[:id]) || current_user
  end

  def show
    @post = Post.find params[:id]
  end

  def like
    post = Post.find params[:id]

    if post.creator == current_user
      flash[:danger] = 'Вы не можете лайкнуть свою статью'
    else
      LikeOf.create(from_node: current_user, to_node: post)
    end

    redirect_to :back
  end

  private

  def post_params
    params.require(:post).permit(:title, :body)
  end
end