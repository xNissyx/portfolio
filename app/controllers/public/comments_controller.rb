class Public::CommentsController < ApplicationController
  before_action :authenticate_user!, only: [:create]

  def create
    @recipe = Recipe.find(params[:recipe_id])
    @comment = current_user.comments.new(comment_params)
    @comment.recipe_id = @recipe.id
    if @comment.save
      respond_to do |format|
        format.js
      end
    else
      flash[:notice] = "コメント内容を入力してください"
      redirect_to recipe_path(@recipe)
    end
  end

  def destroy
    recipe = Recipe.find(params[:recipe_id])
    comment = recipe.comments.find(params[:id])
    comment.destroy
    redirect_to recipe_path(recipe)
  end

  private
    def comment_params
      params.require(:comment).permit(:content, :score)
    end
end
