class HomeController < ApplicationController
  def index
  end

  def convert
    YahooToMagentoOrders.convert(
        params[:orders].tempfile.path,
        params[:orders_products].tempfile.path,
        params[:orders_status].tempfile.path)
    redirect_to success_path
  end

   def download
     File.open("#{Rails.root}/magento_orders_import.csv", 'r') do |f|
       send_data f.read, :type => "text/csv", :filename => "magento_orders_import.csv"
     end
  end
end
