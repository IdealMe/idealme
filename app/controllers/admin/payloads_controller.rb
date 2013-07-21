class Admin::PayloadsController < Admin::BaseController
  # GET /admin/payloads
  def index
    @admin_payloads = Admin::Payload.all
  end

  # GET /admin/payloads/1
  def show
    @admin_payload = Admin::Payload.find(params[:id])
  end

  # GET /admin/payloads/new
  def new
    @admin_payload = Admin::Payload.new
  end

  # GET /admin/payloads/1/edit
  def edit
    @admin_payload = Admin::Payload.find(params[:id])
  end

  # POST /admin/payloads
  def create
    @admin_payload = Admin::Payload.new(params[:admin_payload])
    if @admin_payload.save
      redirect_to @admin_payload, notice: 'Payload was successfully created.'
    else
      render action: "new"
    end
  end

  # PUT /admin/payloads/1
  def update
    @admin_payload = Admin::Payload.find(params[:id])
    if @admin_payload.update_attributes(params[:admin_payload])
      redirect_to @admin_payload, notice: 'Payload was successfully updated.'
    else
      render action: "edit"
    end
  end

  # DELETE /admin/payloads/1
  def destroy
    @admin_payload = Admin::Payload.find(params[:id])
    @admin_payload.destroy
    redirect_to admin_payloads_url
  end
end
