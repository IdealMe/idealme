module LandingsHelper

  def thanks_page_path
    if current_user
      if current_user.ordered_workbook
        "/thanks/thank-you-a"
      else
        "/thanks/thank-you-b"
      end
    else
      "/thanks/thank-you-c"
    end
  end

end

