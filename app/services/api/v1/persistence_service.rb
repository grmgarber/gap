# The purpose of this service is to create all active records associated with the quote at CREATE request
# If the input data are valid, return the token associated with the quote.  The user will be able to
# perform subsequent SHOW/UPDATE/DELETE actions only on the quote with the matching token.
#
#
module Api
  module V1
    class PersistenceService
      def create(quote_params)
        ActionController::Parameters.permit_all_parameters = true
        errors = []
        quote = nil
        Quote.transaction do
          unless quote_params.key?('address')
            errors << 'Quote: Address is missing'
            rollback
          end

          property = Property.create(cap_rate: quote_params['cap_rate'])
          unless property.persisted?
            errors.concat(property.errors.full_messages)
            rollback
          end

          save_record(Address.new(quote_params['address']), property, errors)
          save_record(ExpensesRecord.new(quote_params['expenses']), property, errors)

          if quote_params[:rent_roll].blank?
            errors << 'Rent roll is missing or empty'
            rollback
          end

          quote_params[:rent_roll].each {|unit_roll| save_record(Unit.new(unit_roll), property, errors) }

          quote = Quote.new
          save_record(quote, property, errors)
        end

        [quote, errors]
      end

      def destroy(quote)
        prop = quote.property
        prop.destroy
        prop.destroyed?
      end

      private

      def save_record(record, property, errors)
        record.property = property
        unless record.save
          errors.concat(record.errors.full_messages)
          rollback
        end
      end

      def rollback
        raise ActiveRecord::Rollback, ''
      end
    end
  end
end
