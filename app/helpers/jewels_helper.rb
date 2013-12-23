module JewelsHelper
  def filter_link(label, filter_name)
    link_to label, filter_goal_path(filter_name: filter_name)
  end
end
