module JewelsHelper
  def filter_link(label, filter_name)
    link_class = ''
    link_class = 'active' if params[:filter_name] == filter_name.to_s
    if link_class == 'active'
      content_tag :span, label, class: link_class
    else
      link_to label, filter_goal_path(filter_name: filter_name), class: link_class
    end
  end
end
