require 'rails_helper'

RSpec.describe "API V1 Quotes", type: 'request' do
  let(:headers) { {'Content-Type' => 'application/json', 'Accept' => 'application/json' } }
  let(:valid_params) do
    {
        address: {
            street: '1212 High St',
            city: 'Chicago',
            state: 'IL',
            postal_code: '60654',
            country: 'US'
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
  end

  describe "POST /api/v1/quotes" do
    context "with valid parameters" do
      it "creates a new quote successfully" do
        post "/api/v1/quotes", params: valid_params.to_json, headers: headers

        rb_resp = JSON.parse(response.body).except!("token") # token is random, so kill it
        expect(rb_resp.to_json).to eq("{\"debt_rate\":0.04124,\"loan_amount\":\"869000.0\",\"monthly_payment\":\"8849.51\"}")
      end
    end

    context "with invalid parameters" do
      # Many tests would be needed here for production level code, but I will only implement two tests here
      #
      it "returns an error when address is missing" do
        post "/api/v1/quotes", params: valid_params.except(:address).to_json, headers: headers

        expect(response.body).to eq("{\"errors\":[\"Missing keys: [:address]\"]}")
      end

      it "returns an error when US zip code is invalid" do
        my_params = valid_params.dup
        address = my_params[:address].dup
        address[:postal_code] = "12345-67"
        my_params[:address] = address
        post "/api/v1/quotes", params: my_params.to_json, headers: headers

        expect(response.body).to eq("{\"errors\":[\"Postal code Invalid US postal code\"]}")
      end
    end
  end
end
