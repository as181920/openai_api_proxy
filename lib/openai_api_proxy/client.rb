module OpenaiApiProxy
  class Client
    API_BASE_URI = "https://api.openai.com/".freeze

    InvalidApiKeyError = Class.new StandardError
    ApiResponseError = Class.new StandardError

    attr_reader :api_key, :organization_id

    def initialize(api_key: nil, organization_id: nil)
      @api_key = api_key
      raise InvalidApiKeyError, "OpenAI api secret key missing." if @api_key.blank?

      @organization_id = organization_id
    end

    %w[GET POST PUT PATCH].each do |http_method|
      define_method http_method.underscore do |*args, **kws, &block|
        call_api(http_method, *args, **kws, &block)
      end
    end

    private

      def connection(extra_headers: {})
        Faraday.new(
          url: API_BASE_URI,
          proxy: ENV.fetch("http_proxy", nil).presence,
          headers: {
            Authorization: "Bearer #{api_key}",
            "Content-Type": "application/json",
            "OpenAI-Organization": organization_id
          }.merge(extra_headers).compact
        )
      end

      def call_api(http_method, fullpath, payload = nil, extra_headers: {})
        OpenaiApiProxy.logger.info "#{self.class.name} #{http_method} #{fullpath} reqt: #{payload&.then { |e| e.size > 4096 ? "[FILTERED]" : e }}"
        resp = connection(extra_headers:).public_send(http_method.underscore, fullpath, payload)
        OpenaiApiProxy.logger.info "#{self.class.name} #{http_method} #{fullpath} resp(#{resp.status}): #{squish_response(resp)}"

        parse_response(resp)
      end

      def squish_response(resp)
        resp.body.force_encoding("UTF-8").encode("UTF-8", invalid: :replace, undef: :replace, replace: "").squish
      end

      def parse_response(resp)
        JSON.parse(resp.body).tap do |resp_info|
          raise ApiResponseError, resp_info.dig("error", "message") unless resp.success? # if resp_info["error"].present?
        end
      end
  end
end
