module Api
  module V1
    class QuotesController < ApplicationController

      before_action :ensure_json_request

      # api_v1_quotes_path	POST	/quotes(.:format)	api/v1/quotes#create
      # curl -i -H "Accept: application/json" -H "Content-Type: application/json" -X POST -d '{"json":{"data":"here"}}' http://localhost:3000pi/v1/quotes
      def create
        quote, errors = *persistence_service.create(params[:json])
        render json: {quote: quote, errors: errors}
        # if quote.present?
        #   render json: pricing_service.price(quote)
        # else
        #   render json: errors
        # end
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

      def persistence_service
        Api::V1::PersistenceService.new
      end

      def pricing_service
        Api::V1::PricingService.new
      end
    end
  end
end
