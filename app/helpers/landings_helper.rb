module LandingsHelper

  def thanks_page_path
    if current_user
      ap current_user.orders.to_a
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

