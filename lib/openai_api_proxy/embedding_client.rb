module OpenaiApiProxy
  class EmbeddingClient < Client
    def create(model:, input:, user: "")
      post "/v1/embeddings", { model:, input:, user: }.to_json
    end
  end
end
