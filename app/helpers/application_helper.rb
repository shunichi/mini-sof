module ApplicationHelper
  def pill_class(name, current_page_name)
    name == current_page_name ? 'active' : ''
  end
end
