class CheckAccountValidator < ActiveModel::EachValidator
  def validate_each record, attribute, value
    unless User.find_by("#{attribute}" => value)
      record.errors.add attribute, "id doesn't exist"
    end
  end
end
