module OpenaiApiProxy
  class ChatClient < Client
    def create(params)
      post "/v1/chat/completions", params.to_json
    end
  end
end
