namespace :user do
  desc 'Send a consolidated email of all orders and items to all users.'
  task :send_order_details => [:environment] do |t, args|
    User.all.each do |user|
      OrderMailer.with(user: user).send_orders_summary.deliver_now
    end
  end
end
