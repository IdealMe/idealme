module LandingsHelper
  def thanks_page_path
    if current_user
      if purchased_subscription
        if purchased_workbook
          '/thanks/thank-you-a'
        else
          '/thanks/thank-you-b'
        end
      else
        if purchased_workbook
          '/thanks/thank-you-d'
        else
          '/thanks/thank-you-b'
        end
      end
    else
      '/thanks/thank-you-c'
    end
  end

  def purchased_subscription
    current_user.orders.where('subscription_id IS NOT NULL').count > 0
  end

  def purchased_workbook
    current_user.ordered_workbook
  end

  def after_order_path
    session[:after_order_path] || '/continuity-offer-1'
  end

  def hide_on_ideal_life
    if request.path =~ /ideal-life/
      "hidden"
    end
  end
end