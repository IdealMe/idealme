module Admin::AdminHelper
  def current_tab
    if controller_name == 'articles'
      params[:type] || session[:article_type]
    else
      controller_name
    end
  end

  def drip_content?
    session[:article_type] == "drip_content"
  end
end

