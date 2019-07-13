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
            raise ActiveRecord::Rollback, ''
          end

          property = Property.create(cap_rate: quote_params['cap_rate'])
          unless property.persisted?
            errors.concat(property.errors.full_messages)
            raise ActiveRecord::Rollback, ''
          end

          address = Address.new(quote_params['address'])
          address.property = property
          unless address.save
            errors.concat(address.errors.full_messages)
            raise ActiveRecord::Rollback, ''
          end

          expense_record = ExpensesRecord.new(quote_params['expenses'])
          expense_record.property = property
          unless expense_record.save
            errors.concat(expense_record.errors.full_messages)
            raise ActiveRecord::Rollback, ''
          end

          if quote_params[:rent_roll].blank?
            errors << 'Rent roll is missing or empty'
            raise ActiveRecord::Rollback, ''
          end

          quote_params[:rent_roll].each do |unit_roll|
            unit = Unit.new(unit_roll)
            unit.property = property
            unless unit.save
              errors.concat(unit.errors.full_messages)
              raise ActiveRecord::Rollback, ''
            end
          end


          quote = Quote.new(property: property) # token will be added before validation
          unless quote.save
            errors << quote.errors.full_messages
            raise ActiveRecord::Rollback, ''
          end
        end

        [quote, errors]
      end

      def destroy(quote)
        prop = quote.property
        prop.destroy
        prop.destroyed?
      end
    end
  end
end
