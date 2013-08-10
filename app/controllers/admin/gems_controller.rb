class Admin::GemsController < ApplicationController
  # GET /admin/gems
  # GET /admin/gems.json
  def index
    @admin_gems = Admin::Gem.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @admin_gems }
    end
  end

  # GET /admin/gems/1
  # GET /admin/gems/1.json
  def show
    @admin_gem = Admin::Gem.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @admin_gem }
    end
  end

  # GET /admin/gems/new
  # GET /admin/gems/new.json
  def new
    @admin_gem = Admin::Gem.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @admin_gem }
    end
  end

  # GET /admin/gems/1/edit
  def edit
    @admin_gem = Admin::Gem.find(params[:id])
  end

  # POST /admin/gems
  # POST /admin/gems.json
  def create
    @admin_gem = Admin::Gem.new(params[:admin_gem])

    respond_to do |format|
      if @admin_gem.save
        format.html { redirect_to @admin_gem, notice: 'Gem was successfully created.' }
        format.json { render json: @admin_gem, status: :created, location: @admin_gem }
      else
        format.html { render action: "new" }
        format.json { render json: @admin_gem.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /admin/gems/1
  # PUT /admin/gems/1.json
  def update
    @admin_gem = Admin::Gem.find(params[:id])

    respond_to do |format|
      if @admin_gem.update_attributes(params[:admin_gem])
        format.html { redirect_to @admin_gem, notice: 'Gem was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @admin_gem.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/gems/1
  # DELETE /admin/gems/1.json
  def destroy
    @admin_gem = Admin::Gem.find(params[:id])
    @admin_gem.destroy

    respond_to do |format|
      format.html { redirect_to admin_gems_url }
      format.json { head :no_content }
    end
  end
end
