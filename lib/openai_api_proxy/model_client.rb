module OpenaiApiProxy
  class ModelClient < Client
    def list
      get "/v1/models"
    end

    def retrieve(model)
      get "/v1/models/#{model}"
    end
  end
end
