class PayloadController < ApplicationController
  def download
    payload = Payload.find params[:id]
    redirect_to payload.download_url
  end
end
