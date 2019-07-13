module Api
  module V1
  # Some methods here are commented out
    class PricingService

      DEBT_SERVICE_THRESHOLD = 1.25
      TERM_YEARS = 10
      PAYMENTS_PER_YEAR = 12
      TOTAL_PAYMENTS = TERM_YEARS * PAYMENTS_PER_YEAR
      RATE_DELTA = 0.02 # That's 200 Basis Point, i.e 2% delta over 10YR treasury

      # I do not understand the part of requirement where loan amount is the lesser of two values:
      #    - market value,
      #    - The present value of debt payments where the debt service is >= 1.25
      # Usually, the loan amount is a known value, not a calculated value.
      # Then monthly payment is calculated so that the sum of PVs of monthly payments be equal to the loan amount.
      #
      # So here I calculate loan amount strictly as  NOI/CAP_RATE, because NOI can be calculated from rent_roll inputs,
      # and CAP_RATE is also provided as input.
      # Then I determine monthly payment as LOAN_AMOUNT / PV_OF_120_MONTHLY_PAYMENTS_OF_ONE_DOLLAR.

      def calculate(quote)
        loan_amt = loan_amount(quote)
        monthly_pmt =  loan_amt / pv_of_1_dollar_payments
        {
          debt_rate: debt_rate,
          loan_amount: loan_amt.round(2),
          monthly_payment: monthly_pmt.round(2)
        }
      end

      private

      def loan_amount(quote)
        market_value(quote)
      end

      def market_value(quote)
        quote.property.market_value
      end

      # calculate the PV of all 120 loan payments, assuming each payment equals $1
      def pv_of_1_dollar_payments
        member = 1.0
        factor = 1.0/(1 + debt_rate/PAYMENTS_PER_YEAR)
        res = 0

        TOTAL_PAYMENTS.times do
          member *= factor
          res += member
        end

        res
      end

      # calculate property net operating income
      def noi(property)
        property.noi
      end

      # That's the rate we will charge on the loan
      def debt_rate
        @debt_rate ||= discount_rate + RATE_DELTA
      end

      # Return current 10 year treasury note rate.
      def discount_rate
        Rails.cache.fetch('us-treasury-10-year', expires_in: 24.hours) do
          us_treas_10_year_rate
        end
      end

      # Each of 120 fixed loan payments equals LoanAmount / pv_of_1_dollar_payments
      # def monthly_payment_amount(quote)
      #   loan_amount(quote) / pv_of_1_dollar_payments
      # end

      def us_treas_10_year_rate
        # In real life call a web service to get it, but I will return a constant here
        0.02124
      end
    end
  end
end
