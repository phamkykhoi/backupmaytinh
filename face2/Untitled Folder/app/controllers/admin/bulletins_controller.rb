class Admin::BulletinsController < Admin::BaseController
  def new
    @bulletin = Bulletin.new
  end

  def edit
    set_instance
  end

  def create
    if  @bulletin.save
      redirect_to admin_bulletins_path
    else
      redirect_to :back
    end
  end

  def update
    if @bulletin.update model_params
      redirect_to admin_bulletins_path
    else
      redirect_to :back
    end
  end

  private
  def set_instances
    @bulletins = Bulletin.latest.page(params[:page])
  end
end
