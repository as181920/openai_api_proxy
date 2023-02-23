module OpenaiApiProxy
  class FileClient < Client
    def list
      get "/v1/files"
    end

    def create(file:, purpose: "fine-tune")
      payload = { file: Faraday::Multipart::FilePart.new(file, "text/json"), purpose: }
      post "/v1/files", payload, extra_headers: { "content-type" => "multipart/form-data" }
    end

    def destroy(file_id)
      delete "/v1/files/#{file_id}"
    end

    def retrieve(file_id)
      get "/v1/files/#{file_id}"
    end

    def read(file_id)
      get "/v1/files/#{file_id}/content"
    end
  end
end
