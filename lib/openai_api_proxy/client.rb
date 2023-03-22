module OpenaiApiProxy
  class Client
    API_BASE_URI = "https://api.openai.com/".freeze

    InvalidApiKeyError = Class.new StandardError
    InvalidRequestError = Class.new StandardError
    ServerError = Class.new StandardError
    InternalError = Class.new StandardError
    ApiResponseError = Class.new StandardError

    attr_reader :api_key, :organization_id

    def initialize(api_key: nil, organization_id: nil)
      @api_key = api_key
      raise InvalidApiKeyError, "OpenAI api secret key missing." if @api_key.blank?

      @organization_id = organization_id
    end

    %w[GET POST PUT PATCH DELETE].each do |http_method|
      define_method http_method.underscore do |*args, **kws, &block|
        call_api(http_method, *args, **kws, &block)
      end
    end

    private

      def connection(extra_headers: {}) # rubocop:disable Metrics/MethodLength
        Faraday.new(
          url: API_BASE_URI,
          proxy: ENV.fetch("http_proxy", nil).presence,
          headers: {
            Authorization: "Bearer #{api_key}",
            "OpenAI-Organization": organization_id,
            "Content-Type": "application/json"
          }.merge(extra_headers).compact,
          request: { timeout: ENV.fetch("openai_api_timeout", 300).to_i }
        ) do |conn|
          conn.request :multipart if extra_headers["content-type"]&.start_with?("multipart")
        end
      end

      def call_api(http_method, fullpath, payload = nil, extra_headers: {}, &block)
        OpenaiApiProxy.logger.info "#{self.class.name} #{http_method} #{fullpath} reqt: #{payload&.then { |e| e.size > 4096 ? "[FILTERED]" : e }}"
        resp = connection(extra_headers:).public_send(http_method.underscore, fullpath, payload, &block)
        OpenaiApiProxy.logger.info "#{self.class.name} #{http_method} #{fullpath} resp(#{resp.status}): #{squish_response(resp)}"

        parse_response(resp)
      end

      def squish_response(resp)
        resp.body.force_encoding("UTF-8").encode("UTF-8", invalid: :replace, undef: :replace, replace: "").squish.truncate(2048)
      end

      def parse_response(resp)
        return resp.body if resp.headers["content-type"].in?(%w[application/octet-stream text/event-stream])

        JSON.parse(resp.body).tap do |resp_info|
          # if resp_info["error"].present?
          unless resp.success?
            error_class = "OpenaiApiProxy::Client::#{resp_info.dig("error", "type")&.underscore&.camelize}".safe_constantize || ApiResponseError
            error_message = resp_info.dig("error", "message")
            raise error_class, error_message
          end
        end
      end
  end
end
