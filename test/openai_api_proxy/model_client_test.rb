require "test_helper"

module OpenaiApiProxy
  describe ModelClient do
    before do
      @client = ModelClient.new(api_key: "FILLER")
    end

    it "create completion" do
      stub_request(:get, "https://api.openai.com/v1/models")
        .to_return(
          status: 200,
          body: {
            data: [
              {
                id: "model-id-0",
                object: "model",
                owned_by: "organization-owner",
                permission: []
              },
              {
                id: "model-id-1",
                object: "model",
                owned_by: "organization-owner",
                permission: []
              }
            ],
            object: "list"
          }.to_json,
          headers: {}
        )

      resp_info = @client.list

      assert_equal "list", resp_info["object"]
      assert_equal "model", resp_info.dig("data", 0, "object")
    end
  end
end
