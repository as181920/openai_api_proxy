require "test_helper"

module OpenaiApiProxy
  describe ChatClient do
    before do
      @client = ChatClient.new(api_key: "FILLER")
    end

    it "create completion" do
      params = {
        model: "gpt-3.5-turbo",
        messages: [
          { role: "system", content: "You are a helpful assistant." },
          { role: "user", content: "Tell some about ChatGPT?" }
        ]
      }
      stub_request(:post, "https://api.openai.com/v1/chat/completions")
        .with(body: params.to_json)
        .to_return(
          status: 200,
          body: {
            id: "chatcmpl-123", object: "chat.completion", created: 1677652288,
            choices: [
              { index: 0, message: { role: "assistant", content: "\n\nHello there, how may I assist you today?" }, finish_reason: "stop" }
            ],
            usage: { prompt_tokens: 9, completion_tokens: 12, total_tokens: 21 }
          }.to_json,
          headers: {}
        )

      resp_info = @client.create params

      assert_equal "chat.completion", resp_info["object"]
      assert_equal "assistant", resp_info.dig("choices", 0, "message", "role")
      refute_empty resp_info.dig("choices", 0, "message", "content")
    end
  end
end
