class Dashboard::PaymentsController < Dashboard::ApplicationController
  before_filter :authenticate

  def index
    @payments = ::Payment.where(:owner_id => current_user.id).all
  end

  def show
    @payment = Payment.where(:slub => params[:id]).first
    raise(IdealMeException::RecordNotFound, 'That payment does not exist') if @payment.nil?
    # Authorize the request
    authorize!(:read, @payment)
  end

  def new
    @payment = Payment.new
    # Authorize the request
    authorize!(:create, @payment)
  end

  def edit
    @payment = Payment.where(:slug => params[:id]).first
    raise(IdealMeException::RecordNotFound, 'That payment does not exist') if @payment.nil?
    # Authorize the request
    authorize!(:update, @payment)
  end

  def create
    @payment = Payment.new(params[:payment])
    # Authorize the request
    authorize!(:create, @payment)
    if @payment.save
      #redirect_to @payment, notice: 'Payment was successfully created.'
      redirect_to dashboard_payments_url
    else
      render action: "new"
    end
  end

  def update
    @payment = Payment.where(:slug => params[:id]).first
    raise(IdealMeException::RecordNotFound, 'That payment does not exist') if @payment.nil?
    # Authorize the request
    authorize!(:update, @payment)
    if @payment.update_attributes(params[:payment])
      #redirect_to @payment, notice: 'Payment was successfully updated.'
      redirect_to dashboard_payments_url
    else
      render action: "edit"
    end
  end

  def destroy
    @payment = Payment.where(:slug => params[:id]).first
    raise(IdealMeException::RecordNotFound, 'That payment does not exist') if @payment.nil?
    # Authorize the request
    authorize!(:destroy, @payment)
    @payment.destroy if current_user.affiliate_default_payment_id != @payment.id
    redirect_to dashboard_payments_url
  end

  private
  def authenticate
    authorize!(:access, :payment)
  end
end