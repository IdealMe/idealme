require 'typhoeus/adapters/faraday'

class PayPal
  attr :approval_url
  attr :id

  def get_token
    # How to handle re-use of token?
    # redis!

    conn.basic_auth(*paypal_credentials)

    response = conn.post('/v1/oauth2/token') do |request|
      request.headers['Accept'] = 'application/json'
      request.headers['Accept-Language'] = 'en_US'
      request.body = ''
      request.params['grant_type'] = 'client_credentials'
    end

    json = JSON.parse(response.body)
    json["access_token"]
  end

  def create_payment(total, description)

    body = {
      intent: 'sale',
      redirect_urls: {
        return_url: 'https://idealme.com/paypal/success',
        cancel_url: 'https://idealme.com/paypal/cancel'
      },
      payer: { payment_method: 'paypal' },
      transactions: [
        {
          amount: {
            total: total,
            currency: 'USD'
          },
          description: description
        }
      ]
    }

    response = conn.post('/v1/payments/payment') do |request|
      request.headers['Content-Type'] = 'application/json'
      request.headers['Authorization'] = "Bearer #{get_token}"
      request.body = body.to_json
    end

    json          = JSON.parse(response.body)
    @approval_url = json["links"].detect { |link| link["rel"] == 'approval_url' }['href']
    @id           = json['id']
    
    json
  end

  protected

  def conn
    @conn ||= Faraday.new(:url => endpoint) do |faraday|
      faraday.request  :url_encoded             # form-encode POST params
      faraday.response :logger                  # log requests to STDOUT
      faraday.adapter  :typhoeus  # make requests with Net::HTTP
    end
  end

  def endpoint
    ENV['PAYPAL_ENDPOINT']
  end

  def paypal_credentials
    [
      ENV['PAYPAL_AUTH_KEY'],
      ENV['PAYPAL_AUTH_SECRET']
    ]
  end

end
