module ApplicationHelper
  def get_title
    base_title = 'App'
    ( action_name.nil? ) ? base_title : "#{base_title} | #{action_name.capitalize}"
  end
end
