class LecturesController < ApplicationController
  before_filter :require_authentication

  # GET /lectures
  def index
    @lectures = Lecture.all
  end

  # GET /lectures/1
  def show
    @lecture = Lecture.find(params[:id])
  end
end
