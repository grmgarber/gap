module Api
  module V1
    class QuotesController < ApplicationController

      before_action :ensure_json_request, only: %i[create update] # show and delete have no parameters

      # CREATE method returns a security token associated with the quote.
      # User must submit this token with SHOW/UPDATE/DELETE requests.  This ensures that only the quote creators
      # or their agents can access their quotes.
      # The token plays the role of ID in SHOW/UPDATE/DELETE requests

      # api_v1_quotes_path	POST	/quotes(.:format)	api/v1/quotes#create
      def create
        quote, errors = *persistence_service.create(params)
        if quote.present?
          render json: pricing_service.calculate(quote).merge(token: quote.token)
        else
          render json: {errors: errors }, status: :bad_request
        end
      end

      # api_vi_quote_path	GET	/quotes/:id(.:format) api/v1/quotes#show
      # Use the value of token returned from CREATE request as :id
      def show
        quote = Quote.find_by(token: params[:id])
        if quote.present?
          render json: pricing_service.calculate(quote)
        else
          render_unauthorized
        end
      end

      # api_vi_quote_path	PATCH/PUT	/quotes/:id(.:format) api/v1/quotes#update
      # Use the value of token returned from CREATE request as :id
      #
      # NOT IMPLEMENTING UPDATE TO SAVE TIME
      # 
      # def update
      #
      # end

      # api_v1_quote_path	DELETE	/quotes/:id(.:format) api/v1/quotes#destroy
      # Use the value of token returned from CREATE request as :id
      def destroy
        quote = Quote.find_by(token: params[:id])
        if quote.present?
          if persistence_service.destroy(quote)
            render json: { status: 'Quote and all associated data deleted'}
          else
            render json: { status: 'Failed to delete quote' }
          end
        else
          render_unauthorized
        end
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

      def render_unauthorized
        render json: {error: "Invalid id(security token): #{params[:id]}"}, status: :unauthorized
      end
    end
  end
end
