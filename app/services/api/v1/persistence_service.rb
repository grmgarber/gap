# The purpose of this service is to create all active records associated with the quote at CREATE request
# If the input data are valid, return the token associated with the quote.  The user will be able to
# perform subsequent SHOW/UPDATE/DELETE actions only on the quote with the matching token.
#
#
module Api
  module V1
    class PersistenceService

      REQUIRED_KEYS = %i[address cap_rate expenses rent_roll]

      def create(quote_params)
        errors = []
        quote = nil
        Quote.transaction do
          actual_keys = quote_params.except(:action, :controller, :quote).keys.sort.map(&:to_sym)
          unless actual_keys == REQUIRED_KEYS
            errors << "Missing keys: #{REQUIRED_KEYS - actual_keys}" unless (REQUIRED_KEYS - actual_keys).empty?
            errors << "Unknown keys: #{actual_keys - REQUIRED_KEYS}" unless (actual_keys - REQUIRED_KEYS).empty?
            rollback
          end

          property = Property.create(cap_rate: quote_params[:cap_rate])
          unless property.persisted?
            errors.concat(property.errors.full_messages)
            rollback
          end

          save_record(Address.new(quote_params[:address].permit(:street, :city, :state, :postal_code, :country)),
                      property,
                      errors)
          save_record(ExpensesRecord.new(quote_params[:expenses].permit(*ExpensesRecord::CHECKED_ATTRIBUTES)),
                      property,
                      errors)

          if quote_params[:rent_roll].blank?
            errors << 'Rent roll is missing or empty'
            rollback
          end

          quote_params[:rent_roll].each do |unit_roll|
            save_record(Unit.new(unit_roll.permit(*Unit::MY_ATTRIBUTES)), property, errors)
          end

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
