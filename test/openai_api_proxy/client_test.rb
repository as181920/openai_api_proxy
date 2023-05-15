require "test_helper"

module OpenaiApiProxy
  describe Client do
    it "should use custom api base url from configuration" do
      "https://api_proxy_host.com/base_path".then do |custom_base_url|
        OpenaiApiProxy.configuration.api_base_url = custom_base_url

        assert_equal OpenaiApiProxy.api_base_url, Client.new(api_key: "FILLER").send(:connection).url_prefix.to_s
      end

      ENV.fetch("openai_api_base_url", Configuration::DEFAULT_API_BASE_URL).then do |default_base_url|
        OpenaiApiProxy.configuration.api_base_url = default_base_url

        assert_equal OpenaiApiProxy.api_base_url, Client.new(api_key: "FILLER").send(:connection).url_prefix.to_s
      end
    end

    it "ensure api_key presence" do
      assert_raises Client::InvalidApiKeyError do
        Client.new
      end
    end

    describe "call api" do
      before do
        @client = Client.new(api_key: "FILLER")
      end

      it "create completion" do
        payload = { model: "text-davinci-003", prompt: "Say this is a test", max_tokens: 1024, temperature: 0.1 }.to_json
        stub_request(:post, "https://api.openai.com/v1/completions")
          .with(body: payload)
          .to_return(
            status: 200,
            body: {
              id: "cmpl-uqkvlQyYK7bGYrRHQ0eXlWi7",
              object: "text_completion",
              created: 1589478378,
              model: "text-davinci-003",
              choices: [
                {
                  text: "\n\nThis is indeed a test",
                  index: 0,
                  logprobs: nil,
                  finish_reason: "length"
                }
              ],
              usage: {
                prompt_tokens: 5,
                completion_tokens: 7,
                total_tokens: 12
              }
            }.to_json,
            headers: {}
          )

        resp_info = @client.post "/v1/completions", payload

        refute_empty resp_info.dig("choices", 0, "text")
        assert_equal "text_completion", resp_info["object"]
      end
    end
  end
end
