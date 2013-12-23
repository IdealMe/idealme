module JewelsHelper
  def filter_link(label, filter_name)
    link_class = ''
    link_class = 'active' if params[:filter_name] == filter_name.to_s
    link_to label, filter_goal_path(filter_name: filter_name), class: link_class
  end
end
