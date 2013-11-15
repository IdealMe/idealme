namespace :orders do
  desc "Load a bunch of fake orders"
  task :load_fakes => :environment do
    Order.destroy_all
    CourseUser.destroy_all
    AffiliateSale.destroy_all
    users = User.where(access_admin: false, access_affiliate: false).all
    charlie = User.find 2
    courses = Course.all
    users.each do |user|
      course = courses.shuffle.first
      order = Order.create_order_by_market_and_user(course.default_market, user)
      order.gateway = Order::GATEWAY_PAYPAL
      order.status = Order::STATUS_SUCCESSFUL
      order.save!
      CourseUser.create!(user_id: user.id, course_id: course.id)
      AffiliateSale.create_affiliate_sale(order, charlie)
    end
  end
end
