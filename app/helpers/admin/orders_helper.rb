module Admin::OrdersHelper
  def order_type(order)
    if order.workbook?
      "workbook"
    elsif order.subscription?
      "subscription"
    elsif order.course?
      "course"
    else
      "workbook"
    end
  end
end