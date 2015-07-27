class Admin::PostsController < Admin::BaseController
  skip_before_action :set_instance, only: [:update]

  def index
    return render params[:template] if params[:template]
  end

  def update
    @post = model.with_deleted.find params[:id]
    if params[:_restore]
      @post.restore recursive: true
      @post.update supporters_count: @post.supporterships.count,
        comments_count: @post.comments.count
      redirect_to :back
    end
  end

  private
  def set_instances
    case params[:template]
    when "bans"
      instance_variable_set "@#{model_name.pluralize}",
        model.with_bans_count.page(params[:page])
    else
      instance_variable_set "@#{model_name.pluralize}",
        model.with_deleted.includes(:photos).recent.page(params[:page])
          .per(Settings.returning_post_num_for_admin)
    end
  end
end
