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

  let(:wrong_token) { '1a2b3c4d' }
  let(:invalid_token_error) { "{\"error\":\"Invalid id(security token): 1a2b3c4d\"}" }

  describe "GET /api/v1/quotes" do
    context "with valid token" do
      it "displays the existing quote info" do
        post "/api/v1/quotes", params: valid_params.to_json, headers: headers
        token = JSON.parse(response.body)['token']

        get "/api/v1/quotes/#{token}" # We do not require SHOW to be JSON only, as there are no parameters

        rb_resp = JSON.parse(response.body).except!("token")

        expect(rb_resp.to_json).to eq("{\"debt_rate\":0.04124,\"loan_amount\":\"869000.0\",\"monthly_payment\":\"8849.51\"}")
      end
    end

    context "with invalid token" do
      it "produces security token violation error when the token does not match any of db records" do
        get "/api/v1/quotes/#{wrong_token}"

        expect(response.body).to eq(invalid_token_error)
      end
    end
  end

  describe "DELETE /api/v1/quotes" do
    context "with valid token" do
      it "deletes the existing quote successfully" do
        # Create a new quote
        post "/api/v1/quotes", params: valid_params.to_json, headers: headers
        token = JSON.parse(response.body)['token']

        # Now delete it
        expect {delete "/api/v1/quotes/#{token}"}.to change{Quote.count}.by(-1)
        expect(response.body).to eq("{\"status\":\"Quote and all associated data deleted\"}")
      end
    end

    context "with invalid token" do
      let(:wrong_token) { '1a2b3c4d' }

      it "produces security token violation error when the token does not match any of db records" do
        # Create a new quote
        post "/api/v1/quotes", params: valid_params.to_json, headers: headers

        expect {delete "/api/v1/quotes/#{wrong_token}"}.to change{Quote.count}.by(0)
        expect(response.body).to eq(invalid_token_error)
      end
    end
  end
end
