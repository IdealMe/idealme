class Dashboard::RedirectionsController < ApplicationController
  def index
    @redirections = current_user.redirections
  end

  def show
    @redirection = ::Redirection.where(:slug => params[:id]).first
    raise(IdealMeException::RecordNotFound, 'That redirection does not exist') if @redirection.nil?
  end

  def new
    @redirection = ::Redirection.new
  end

  def edit
    @redirection = ::Redirection.find(params[:id])
  end

  def create
    @redirection = ::Redirection.new(params[:redirection])

    if @redirection.save
      redirect_to dashboard_redirection_path(@redirection), notice: 'Redirection was successfully created.'
    else
      render action: "new"
    end
  end

  def update
    @redirection = ::Redirection.find(params[:id])
    if @redirection.update_attributes(params[:redirection])
      redirect_to dashboard_redirection_path(@redirection), notice: 'Redirection was successfully updated.'
    else
      render action: "edit"
    end
  end

  def destroy
    @redirection = ::Redirection.find(params[:id])
    @redirection.destroy
    redirect_to dashboard_redirections_url
  end

end
