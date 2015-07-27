module V2::Authority
  extend ActiveSupport::Concern

  included do
     before_action :can_delete, only: [:destroy]
  end

  def can_delete
    return head :bad_request unless deletable?
  end

  private
  def deletable?
    case instance.class.name
    when Comment.name
      instance.post.user == current_user || instance.user_id == current_user.id
    else
      instance.user_id == current_user.id
    end
  end
end