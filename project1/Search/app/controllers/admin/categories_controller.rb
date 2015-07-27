class Admin::CategoriesController < Admin::AdminController
  def index
    @categories = Category.paginate page: params[:page], per_page: 15
  end

  def new
    @category = Category.new
  end

  def edit
    @category = Category.find params[:id]
  end

  def create
    @category = Category.new categorie_params
    if @category.save
      redirect_to admin_categories_path
    else
      render "new"
    end
  end

  def update
    @category = Category.find params[:id]
    if @category.update_attributes categorie_params
      redirect_to admin_categories_path
    else
      render "edit"
    end
  end

  def destroy
    Category.find(params[:id]).destroy
    redirect_to admin_categories_path
  end

  private
  def categorie_params
    params.require(:category).permit :name
  end
end