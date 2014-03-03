module ResourcesHelper
  def download_url
    if current_user
      'http://idealme-prod.s3.amazonaws.com/Design_Your_Ideal_Life_Workbook.pdf'
    else
      "#{root_path}#sign-up"
    end
  end
end
