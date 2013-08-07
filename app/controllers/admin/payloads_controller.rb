class Admin::PayloadsController < Admin::BaseController
  before_filter :set_parent

  # List the payloads
  def index
    @payloads = @payload_parent.payloads
  end

  # Show a specific payload
  def show
    @payload = Payload.where(:id => params[:id]).first
  end

  # Create a specific payload
  def new
    @payload = Payload.new
  end

  # Edit a specific payload
  def edit
    @payload = Payload.where(:id => params[:id]).first
  end

  # Create a specific payload
  def create
    @payload = Payload.new(params[:payload])
    if @payload.save
      redirect_to @payload, :notice => 'Payload was successfully created.'
    else
      render :new
    end
  end

  # Update a specific payload
  def update
    @payload = Payload.where(:id => params[:id]).first
    if @payload.update_attributes(params[:payload])
      redirect_to @payload, :notice => 'Payload was successfully updated.'
    else
      render :edit
    end
  end

  # Destroy a specific payload
  def destroy
    @payload = Payload.where(:id => params[:id]).first
    @payload.destroy
    redirect_to payloads_url
  end

  private
  # Relative path helper for the url of a single payload
  #
  # @todo What is the parameter *payload* used for?
  # @return [String] The relative path for the url of a single payload with respect to *Market*, *Lecture*, or *Article*
  # @see Market
  # @see Lecture
  # @see Article
  def payload_url(payload = nil)
    case @payload_parent.class.name
      when 'Market'
        admin_market_payload_url(@payload_parent, payload)
      when 'Lecture'
        admin_lecture_payload_url(@payload_parent, payload)
      when 'Article'
        admin_article_payload_url(@payload_parent, payload)
    end
  end

  # Relative path helper for the url of the list of payloads
  #
  # @todo What is the parameter *payload* used for?
  # @return [String] The relative path for the url of the list of payloads with respect to *Market*, *Lecture*, or *Article*
  # @see Market
  # @see Lecture
  # @see Article
  def payloads_url
    case @payload_parent.class.name
      when 'Market'
        admin_market_payloads_url
      when 'Lecture'
        admin_lecture_payloads_url
      when 'Article'
        admin_article_payloads_url
    end
  end

  # Set the parent of the nested resource
  # @see Market
  # @see Lecture
  # @see Article
  def set_parent
    @payload_parent = nil
    if params[:market_id]
      @payload_parent = ::Market.where(:slug => params[:market_id]).first
    elsif params[:lecture_id]
      @payload_parent = ::Lecture.where(:slug => params[:lecture_id]).first
    elsif params[:article_id]
      @payload_parent = ::Article.where(:slug => params[:article_id]).first
    end
  end
end