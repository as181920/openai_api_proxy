module OpenaiApiProxy
  class FileClient < Client
    def list
      get "/v1/files"
    end

    def create(file:, purpose:)
    end
  end
end
