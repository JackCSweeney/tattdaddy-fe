module ApplicationHelper
  def cache_key_with_version(model_class, label = "")
    prefix = model_class.to_s.downcase.pluralize
    id = model_class.id
    [prefix, label, id].join("-")
  end
end
