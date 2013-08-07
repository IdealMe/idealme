class Admin::OrdersController < ApplicationController
  # GET /admin/orders
  # GET /admin/orders.json
  def index
    @admin_orders = Admin::Order.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @admin_orders }
    end
  end

  # GET /admin/orders/1
  # GET /admin/orders/1.json
  def show
    @admin_order = Admin::Order.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @admin_order }
    end
  end

  # GET /admin/orders/new
  # GET /admin/orders/new.json
  def new
    @admin_order = Admin::Order.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @admin_order }
    end
  end

  # GET /admin/orders/1/edit
  def edit
    @admin_order = Admin::Order.find(params[:id])
  end

  # POST /admin/orders
  # POST /admin/orders.json
  def create
    @admin_order = Admin::Order.new(params[:admin_order])

    respond_to do |format|
      if @admin_order.save
        format.html { redirect_to @admin_order, notice: 'Order was successfully created.' }
        format.json { render json: @admin_order, status: :created, location: @admin_order }
      else
        format.html { render action: "new" }
        format.json { render json: @admin_order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /admin/orders/1
  # PUT /admin/orders/1.json
  def update
    @admin_order = Admin::Order.find(params[:id])

    respond_to do |format|
      if @admin_order.update_attributes(params[:admin_order])
        format.html { redirect_to @admin_order, notice: 'Order was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @admin_order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/orders/1
  # DELETE /admin/orders/1.json
  def destroy
    @admin_order = Admin::Order.find(params[:id])
    @admin_order.destroy

    respond_to do |format|
      format.html { redirect_to admin_orders_url }
      format.json { head :no_content }
    end
  end
end
