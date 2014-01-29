class Webhook::SendGridController < ApplicationController
  def notify
    events.each do |event|
      if event["event"] == "clicked"
        handle_clicks(event)
      end
    end
    head :ok
  end

  protected

  def handle_clicks(event)
    url = event['url']
    user = user_by_email event["email"]
    if user && url
      tags = get_tags_from_url(url)
      unless tags.empty?
        user.interest_list.add(tags)
        user.save!
      end
    end
  end

  def user_by_email(email)
    User.where(email: email).first
  end

  def get_tags_from_url(url)
    uri = URI.parse(url)
    tags = uri.query.split('&').map {|pair| pair.split('=') }.find{|pair| pair[0] == 'iminterest'}.last.split(',')
    tags.map {|tag| tag.strip }
  rescue NoMethodError => e
    []
  end

  def events
    params[:_json]
  end
end
