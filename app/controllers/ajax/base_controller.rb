# Application controller specific to the ajax
class Ajax::BaseController < ::ApplicationController

  respond_to :json
  before_filter :set_im_ajax_results


  rescue_from IdealmeException::Ajax::EarlyBailout do |exception|
    render json: :early_bailout and return
  end

  def set_status_and_error(status, error, exception=IdealmeException::Ajax::EarlyBailout)
    @im_ajax_results.error = error
    @im_ajax_results.status = status
    raise exception
  end

  def set_im_ajax_results
    @im_ajax_results = OpenStruct.new
    @im_ajax_results.error = nil
    @im_ajax_results.status = 200
    @im_ajax_results.path = request.fullpath
    @im_ajax_results.params = params
  end

  protected
  def require_authentication
    unless current_user
      @im_ajax_results.error = 'User is not authenticated'
      @im_ajax_results.status = 401
      render :require_authentication and return
    end
  end
end
