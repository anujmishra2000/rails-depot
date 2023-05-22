class Admin::ReportsController < AdminBaseController
  def index
    params[:from] ||= 5.days.ago
    @order = Order.by_date(params[:from], params[:to])
  end
end
