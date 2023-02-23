require "test_helper"

module OpenaiApiProxy
  describe FileClient do
    before do
      @client = FileClient.new(api_key: "FILLER")
    end

    it "list files" do
      stub_request(:get, "https://api.openai.com/v1/files")
        .to_return(
          status: 200,
          body: {
            object: "list",
            data: [
              {
                id: "file-ccdDZrC3iZVNiQVeEA6Z66wf",
                object: "file",
                bytes: 175,
                created_at: 1613677385,
                filename: "train.jsonl",
                purpose: "search"
              }
            ]
          }.to_json
        )
      resp_info = @client.list

      assert_equal "list", resp_info["object"]
      refute_empty resp_info["data"]
      assert_equal "file", resp_info.dig("data", 0, "object")
    end

    it "create file" do
      stub_request(:post, "https://api.openai.com/v1/files")
        .to_return(
          status: 200,
          body: {
            object: "list",
            data: [
              {
                object: "file", id: "file-FILLER1", purpose: "fine-tune", filename: "openai_buddhism.json", bytes: 134203,
                created_at: 1677144000, status: "processed", status_details: nil
              }
            ]
          }.to_json,
          headers: {}
        )

      resp_info = @client.create(file: File.open(File.expand_path("../fixtures/files/filler.txt", __dir__), "r"))

      assert_equal "list", resp_info["object"]
      assert_equal "file", resp_info.dig("data", 0, "object")
      refute_empty resp_info.dig("data", 0, "id")
    end

    it "delete file" do
      file_id = "file-FILLER"
      stub_request(:delete, "https://api.openai.com/v1/files/file-FILLER")
        .to_return(
          status: 200,
          body: {
            id: file_id,
            object: "file",
            deleted: true
          }.to_json,
          headers: {}
        )

      resp_info = @client.destroy file_id

      assert_equal file_id, resp_info["id"]
      assert_equal "file", resp_info["object"]
      assert resp_info["deleted"]
    end

    it "retrieve file" do
      file_id = "file-FILLER"
      stub_request(:get, "https://api.openai.com/v1/files/file-FILLER")
        .to_return(
          status: 200,
          body: {
            id: file_id,
            object: "file",
            filename: "name-FILLER"
          }.to_json,
          headers: {}
        )

      resp_info = @client.retrieve file_id

      assert_equal file_id, resp_info["id"]
      assert_equal "file", resp_info["object"]
      refute_empty resp_info["filename"]
    end

    it "retrieve file content" do
      stub_request(:get, "https://api.openai.com/v1/files/file-FILLER/content")
        .to_return(
          status: 200,
          body: "content-FILLER",
          headers: { "content-type" => "application/octet-stream" }
        )

      resp_info = @client.read "file-FILLER"

      assert_equal "content-FILLER", resp_info
    end
  end
end
