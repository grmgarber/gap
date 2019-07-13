module Api
  module V1
  # The purpose of this service is to calculate the loan amount and debt rate and return them, as well as the token
    class PricingService

      DEBT_SERVICE_THRESHOLD = 1.25
      TERM_YEARS = 10
      PAYMENTS_PER_YEAR = 12
      TOTAL_PAYMENTS = TERM_YEARS * PAYMENTS_PER_YEAR
      RATE_DELTA = 0.02 # That's 200 Basis Point, i.e 2% delta over 10YR treasury

      def calculate(quote)
        {
          debt_rate: debt_rate,
          loan_amount: loan_amount(quote)
        }
      end

      private

      def loan_amount(quote)
        value = market_value(quote)

        if debt_service >= DEBT_SERVICE_THRESHOLD
          sum_pv = debt_payments_pv
          value < sum_pv ? value : sum_pv
        else
          value
        end
      end

      def market_value(quote)
        quote.property.market_value
      end

      def debt_payments_pv
        fixed_payment_amount * pv_of_1_dollar_payments
      end

      # calculate the PV of all 120 loan payments, assuming each payment equals $1
      def pv_of_1_dollar_payments
        member = 1.0
        factor = 1.0/(1 + debt_rate)
        res = 0

        TOTAL_PAYMENTS.times do
          member *= factor
          res += member
        end

        res
      end

      # calculate property net operationg income
      def noi(property)
        property.noi
      end

      # That's the rate we will charge on the loan
      def debt_rate
        @debt_rate ||= base_rate + RATE_DELTA
      end

      # Return current 10 year treasury note rate.
      # I will use a constant, but in reality it should be a web service call, with caching
      def base_rate
        0.02124  # as of 7/12/2019
      end

      def total_annual_rent_collected(property)
        property.total_annual_rent_collected
      end

      def debt_service
        noi(property) / debt_payment
      end

      def debt_payment
        debt_rate * loan_proceeds
      end

      # Each of 120 fixed loan payments equals LoanAmount / pv_of_1_dollar_payments
      def fixed_payment_amount
        loan_amount(quote) / pv_of_1_dollar_payments
      end
    end
  end
end
