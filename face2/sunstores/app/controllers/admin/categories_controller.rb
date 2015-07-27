class Admin::CategoriesController < ApplicationController
  load_and_authorize_resource
  
  def index
    @categories = Category.all
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new category_params
    if @category.save
      flash[:success] = I18n.t "message.create"
      redirect_to admin_categories_path
    else
      render "new"
    end
  end

  def edit
    @category = Category.find params[:id]
  end

  def update
    @category = Category.find params[:id]
    if @category.update_attributes category_params
      flash[:success] = I18n.t "message.update"
      redirect_to admin_categories_path
    else
      render "edit"
    end
  end

  def show
    @category = Category.find params[:id]
  end

  def destroy
    Category.find(params[:id]).destroy
    flash[:success] = I18n.t "message.delete"
    redirect_to admin_categories_path
  end

  private
  def category_params
    params.require(:category).permit :name
  end
end