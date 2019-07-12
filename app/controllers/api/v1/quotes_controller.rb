module Api
  module V1
    class QuotesController < ApplicationController

      before_action :ensure_json_request

      # api_v1_quotes_path	POST	/quotes(.:format)	api/v1/quotes#create
      # curl -i -H "Accept: application/json" -H "Content-Type: application/json" -X POST -d '{"json":{"data":"here"}}' http://localhost:3000pi/v1/quotes
      def create
          render json: 'OK'
      end

      # api_vi_quote_path	GET	/quotes/:id(.:format) api/v1/quotes#show
      def show

      end

      # api_vi_quote_path	PATCH/PUT	/quotes/:id(.:format) api/v1/quotes#update
      def update

      end

      # api_v1_quote_path	DELETE	/quotes/:id(.:format) api/v1/quotes#destroy
      def delete

      end

      private

      def ensure_json_request
        return if request.format == :json

        render nothing: true, status: :not_acceptable
      end
    end
  end
end
