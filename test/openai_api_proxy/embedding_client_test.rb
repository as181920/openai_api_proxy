require "test_helper"

module OpenaiApiProxy
  describe EmbeddingClient do
    before do
      @client = EmbeddingClient.new(api_key: "FILLER")
    end

    it "create completion" do
      stub_request(:post, "https://api.openai.com/v1/embeddings")
        .to_return(
          status: 200,
          body: {
            object: "list",
            data: [
              {
                object: "embedding",
                embedding: [0.0023064255, -0.009327292, -0.0028842222],
                index: 0
              }
            ],
            model: "text-embedding-ada-002",
            usage: { prompt_tokens: 8, total_tokens: 8 }
          }.to_json,
          headers: {}
        )

      resp_info = @client.create model: "text-embedding-ada-002", input: "text-FILLER"

      assert_equal "list", resp_info["object"]
      assert_equal "embedding", resp_info.dig("data", 0, "object")
      refute_empty resp_info.dig("data", 0, "embedding")
    end
  end
end
