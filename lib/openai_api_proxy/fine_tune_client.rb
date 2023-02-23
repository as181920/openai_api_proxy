module OpenaiApiProxy
  class FineTuneClient < Client
    # required： training_file
    def create(params = {})
      post "/v1/fine-tunes", params.to_json
    end

    def list
      get "/v1/fine-tunes"
    end

    def retrieve(fine_tune_id)
      get "/v1/fine-tunes/#{fine_tune_id}"
    end

    def cancel(fine_tune_id)
      post "/v1/fine-tunes/#{fine_tune_id}/cancel"
    end

    def list_events(fine_tune_id)
      get "/v1/fine-tunes/#{fine_tune_id}/events"
    end

    def destroy(model_name)
      delete "/v1/models/#{model_name}"
    end
  end
end
