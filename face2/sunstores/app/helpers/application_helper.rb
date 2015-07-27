module ApplicationHelper
  def get_namespace
    namespace = controller_path.split('/').first
  end
end
