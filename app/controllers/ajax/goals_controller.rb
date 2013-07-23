class Ajax::GoalsController < ApplicationController
  # GET /ajax/goals
  # GET /ajax/goals.json
  def index
    @ajax_goals = Ajax::Goal.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @ajax_goals }
    end
  end

  # GET /ajax/goals/1
  # GET /ajax/goals/1.json
  def show
    @ajax_goal = Ajax::Goal.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @ajax_goal }
    end
  end

  # GET /ajax/goals/new
  # GET /ajax/goals/new.json
  def new
    @ajax_goal = Ajax::Goal.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @ajax_goal }
    end
  end

  # GET /ajax/goals/1/edit
  def edit
    @ajax_goal = Ajax::Goal.find(params[:id])
  end

  # POST /ajax/goals
  # POST /ajax/goals.json
  def create
    @ajax_goal = Ajax::Goal.new(params[:ajax_goal])

    respond_to do |format|
      if @ajax_goal.save
        format.html { redirect_to @ajax_goal, notice: 'Goal was successfully created.' }
        format.json { render json: @ajax_goal, status: :created, location: @ajax_goal }
      else
        format.html { render action: "new" }
        format.json { render json: @ajax_goal.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /ajax/goals/1
  # PUT /ajax/goals/1.json
  def update
    @ajax_goal = Ajax::Goal.find(params[:id])

    respond_to do |format|
      if @ajax_goal.update_attributes(params[:ajax_goal])
        format.html { redirect_to @ajax_goal, notice: 'Goal was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @ajax_goal.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ajax/goals/1
  # DELETE /ajax/goals/1.json
  def destroy
    @ajax_goal = Ajax::Goal.find(params[:id])
    @ajax_goal.destroy

    respond_to do |format|
      format.html { redirect_to ajax_goals_url }
      format.json { head :no_content }
    end
  end
end
