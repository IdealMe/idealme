class DiscoversController < ApplicationController
  # GET /discovers
  def index
    @type_select = [['Everything', Jewel::EVERYTHING], ['Goals', Jewel::GOAL], ['Gems', Jewel::LINK], ['Courses', Jewel::COURSE]]
    @sort_select = [['Most popular', 'popular'], ['Most recent', 'recent']]
    type = params[:type].to_i || Jewel::EVERYTHING
    sort = params[:sort] || 'popular'
    @discovers = Jewel
    if type == Jewel::GOAL
      @discovers = @discovers.where(:kind => Jewel::GOAL)
    elsif type == Jewel::LINK
      @discovers = @discovers.where(:kind => Jewel::LINK)
    elsif type == Jewel::COURSE
      @discovers = @discovers.where(:kind => Jewel::COURSE)
    end

    if sort == 'popular'
      @discovers = @discovers.order('up_votes - down_votes DESC')
    else
      @discovers = @discovers.order('created_at DESC')
    end

    @discovers = @discovers.paginate(:page => params[:page], :per_page => 36).all
  end

  # GET /discovers/1
  def show
  end
end
