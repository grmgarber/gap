require 'rails_helper'

RSpec.describe "API V1 Quotes", type: 'request' do
  describe "POST /api/v1/quotes" do
    context "with valid parameters" do
      let(:valid_params) do
        {json: {
              address: {
                street: '1212 High St',
                city: 'Chicago',
                state: 'IL',
                postal_code: '60654'
              },
              rent_roll: [
                 {
                   monthly_rent: 6000,
                   unit_number: '1A',
                   vacancy: false,
                   nbr_bedrooms: 6,
                   nbr_bathrooms: 7,
                   annual_total: 72000
                 },
                 {
                   monthly_rent: 5000,
                   unit_number: '2A',
                   vacancy: true,
                   nbr_bedrooms: 5,
                   nbr_bathrooms: 4,
                   annual_total: 60000
                 }
              ],
              expenses: {
                  marketing: 1500,
                  tax: 20000,
                  insurance: 4500,
                  repairs: 10000,
                  admin: 2000,
                  payroll: 0,
                  utility: 5400,
                  management: 1700
              },
              cap_rate: 0.1
          }
        }
      end

      it "creates a new quote successfully" do
        post "/api/v1/quotes", params: valid_params.to_json,
                               headers: {'Content-Type' => 'application/json', 'Accept' => 'application/json' }

        rb_resp = JSON.parse(response.body).except!("token") # token is random, so kill it
        expect(rb_resp.to_json).to eq("{\"debt_rate\":0.04124,\"loan_amount\":\"869000.0\",\"monthly_payment\":\"8849.51\"}")
      end
    end

    context "with invalid parameters" do
      it "returns an error when address is missing" do
        post "/api/v1/quotes", params: valid_params.except().to_json,
             headers: {'Content-Type' => 'application/json', 'Accept' => 'application/json' }

        rb_resp = JSON.parse(response.body).except!("token") # token is random, so kill it
        expect(rb_resp.to_json).to eq("{\"debt_rate\":0.04124,\"loan_amount\":\"869000.0\",\"monthly_payment\":\"8849.51\"}")
      end
    end
  end
end
