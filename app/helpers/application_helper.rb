module ApplicationHelper
  def get_title overload
    base_title = 'App'
    title = overload ? overload : "#{action_name.capitalize}"
    ( action_name.nil? ) ? base_title : "#{base_title} | #{title}"
  end
end
