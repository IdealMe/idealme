module ResourcesHelper
  def download_url
    if current_user
      'http://idealme.s3.amazonaws.com/Design%20Your%20Ideal%20Life.pdf'
    else
      "#{root_path}#sign-up"
    end
  end
end
