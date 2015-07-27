class V2::M::BaseController < V2::BaseController
  def index
    _instances = model.all
    instance_variable_set "@m_#{model_name.pluralize}", _instances
  end

  private
  def model
    "M::#{controller_name.classify}".safe_constantize
  end
end
