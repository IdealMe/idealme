require 'typhoeus/adapters/faraday'

class PayPal
  attr :approval_url
  attr :id
  attr :endpoint
  attr :credentials

  def initialize(endpoint, credentials)
    @endpoint = endpoint
    @credentials = credentials
  end

  def get_token
    # cache the auth token in redis
    token = $redis.get(credentials.first)
    return token if token

    conn.basic_auth(*credentials)

    response = conn.post('/v1/oauth2/token') do |request|
      request.headers['Accept'] = 'application/json'
      request.headers['Accept-Language'] = 'en_US'
      request.body = ''
      request.params['grant_type'] = 'client_credentials'
    end

    json = JSON.parse(response.body)
    ttl = json["expires_in"] - 60
    $redis.setex(credentials.first, ttl, json["access_token"])

    json["access_token"]
  end

  def create_payment(total, description, return_url, cancel_url)
    body = {
      intent: 'sale',
      redirect_urls: {
        return_url: return_url,
        cancel_url: cancel_url
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

  def execute_payment(id, payer_id, token)
    response = conn.post("/v1/payments/payment/#{id}/execute") do |request|
      request.headers['Content-Type'] = 'application/json'
      request.headers['Authorization'] = "Bearer #{get_token}"
      request.body = { payer_id: payer_id }.to_json
    end

    json          = JSON.parse(response.body)
    json
  end

  protected

  def conn
    @conn ||= Faraday.new(url: endpoint) do |faraday|
      faraday.request  :url_encoded             # form-encode POST params
      #faraday.response :logger                  # log requests to STDOUT
      faraday.adapter  :typhoeus  # make requests with Net::HTTP
    end
  end



end
