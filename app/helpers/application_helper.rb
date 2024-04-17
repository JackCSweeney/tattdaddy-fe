module ApplicationHelper
  def cache_key_with_version(model_class)
    location = model_class.location
    id = model_class.id
    search_radius = model_class.search_radius
    [location, search_radius, id].join("-")
  end
end
