require "test_helper"

module OpenaiApiProxy
  describe CompletionClient do
    before do
      @client = CompletionClient.new(api_key: "FILLER")
    end

    it "create completion" do
      params = { model: "text-davinci-003", prompt: "Say this is a test", max_tokens: 1024, temperature: 0.1 }
      stub_request(:post, "https://api.openai.com/v1/completions")
        .with(body: params.to_json)
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

      resp_info = @client.create params

      refute_empty resp_info.dig("choices", 0, "text")
      assert_equal "text_completion", resp_info["object"]
    end
  end
end
