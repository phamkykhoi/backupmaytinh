module ApplicationHelper
  def selected_item_class path
    return "" unless request.path_info == path
    "selected"
  end
end
