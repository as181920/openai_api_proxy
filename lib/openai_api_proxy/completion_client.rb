module OpenaiApiProxy
  class CompletionClient < Client
    def create(params)
      post "/v1/completions", params.to_json
    end
  end
end
