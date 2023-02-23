require "test_helper"

module OpenaiApiProxy
  describe FineTuneClient do
    before do
      @client = FineTuneClient.new(api_key: "FILLER")
    end

    it "create fine-tune" do
      stub_request(:post, "https://api.openai.com/v1/fine-tunes")
        .to_return(
          status: 200,
          body: {
            id: "ft-AF1WoRqd3aJAHsqc9NY7iL8F",
            object: "fine-tune",
            model: "curie",
            created_at: 1614807352,
            events: [{ object: "fine-tune-event", created_at: 1614807352, level: "info", message: "" }],
            fine_tuned_model: nil,
            hyperparams: { batch_size: 4, learning_rate_multiplier: 0.1, n_epochs: 4, prompt_loss_weight: 0.1 },
            organization_id: "org-...",
            result_files: [],
            status: "pending",
            validation_files: [],
            training_files: [
              {
                id: "file-XGinujblHPwGLSztz8cPS8XY", object: "file", bytes: 1547276, created_at: 1610062281,
                filename: "my-data-train.jsonl", purpose: "fine-tune-train"
              }
            ],
            updated_at: 1614807352
          }.to_json
        )
      resp_info = @client.create training_file: "file_id"

      assert_equal "fine-tune", resp_info["object"]
      refute_empty resp_info["model"]
    end

    it "list fine-tune" do
      stub_request(:get, "https://api.openai.com/v1/fine-tunes")
        .to_return(
          status: 200,
          body: {
            object: "list",
            data: [
              {
                id: "ft-AF1WoRqd3aJAHsqc9NY7iL8F",
                object: "fine-tune",
                model: "curie",
                created_at: 1614807352,
                fine_tuned_model: nil,
                hyperparams: {},
                organization_id: "org-...",
                result_files: [],
                status: "pending",
                validation_files: [],
                training_files: [{}],
                updated_at: 1614807352
              }
            ]
          }.to_json
        )
      resp_info = @client.list

      assert_equal "list", resp_info["object"]
      assert_equal "fine-tune", resp_info.dig("data", 0, "object")
      refute_empty resp_info.dig("data", 0, "id")
    end

    it "retrieve fine-tune" do
      stub_request(:get, "https://api.openai.com/v1/fine-tunes/id-filler")
        .to_return(
          status: 200,
          body: {
            id: "ft-AF1WoRqd3aJAHsqc9NY7iL8F",
            object: "fine-tune",
            model: "curie",
            created_at: 1614807352,
            events: [{ object: "fine-tune-event", created_at: 1614807352, level: "info", message: "" }],
            fine_tuned_model: "curie:ft-acmeco-2021-03-03-21-44-20",
            organization_id: "org-...",
            result_files: [
              { id: "file-QQm6ZpqdNwAaVC3aSz5sWwLT", object: "file", filename: "compiled_results.csv", purpose: "fine-tune-results" }
            ],
            status: "succeeded",
            validation_files: [],
            training_files: [
              {
                id: "file-XGinujblHPwGLSztz8cPS8XY", object: "file", bytes: 1547276,
                created_at: 1610062281, filename: "my-data-train.jsonl", purpose: "fine-tune-train"
              }
            ],
            updated_at: 1614807865
          }.to_json
        )
      resp_info = @client.retrieve "id-filler"

      assert_equal "fine-tune", resp_info["object"]
      refute_empty resp_info["fine_tuned_model"]
    end

    it "cancel fine-tune" do
      stub_request(:post, "https://api.openai.com/v1/fine-tunes/id-filler/cancel")
        .to_return(
          status: 200,
          body: {
            id: "ft-xhrpBbvVUzYGo8oUO1FY4nI7",
            object: "fine-tune",
            model: "curie",
            created_at: 1614807770,
            events: [{}],
            fine_tuned_model: nil,
            hyperparams: {},
            organization_id: "org-...",
            result_files: [],
            status: "cancelled",
            validation_files: [],
            training_files: [
              {
                id: "file-XGinujblHPwGLSztz8cPS8XY", object: "file", bytes: 1547276, created_at: 1610062281,
                filename: "my-data-train.jsonl", purpose: "fine-tune-train"
              }
            ],
            updated_at: 1614807789
          }.to_json
        )
      resp_info = @client.cancel "id-filler"

      assert_equal "fine-tune", resp_info["object"]
      assert_equal "cancelled", resp_info["status"]
    end

    it "list fine-tune events" do
      stub_request(:get, "https://api.openai.com/v1/fine-tunes/id-filler/events")
        .to_return(
          status: 200,
          body: {
            object: "list",
            data: [
              { object: "fine-tune-event", created_at: 1614807352, level: "info", message: "" }
            ]
          }.to_json
        )
      resp_info = @client.list_events "id-filler"

      assert_equal "list", resp_info["object"]
      assert_equal "fine-tune-event", resp_info.dig("data", 0, "object")
    end

    it "delete fine-tune model" do
      model_name = "MODEL_NAME_FILLER"
      stub_request(:delete, "https://api.openai.com/v1/models/#{model_name}")
        .to_return(
          status: 200,
          body: {
            id: model_name,
            object: "model",
            deleted: true
          }.to_json
        )
      resp_info = @client.destroy model_name

      assert_equal "model", resp_info["object"]
      assert resp_info["deleted"]
    end
  end
end
