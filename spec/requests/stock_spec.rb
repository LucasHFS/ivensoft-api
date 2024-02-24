# frozen_string_literal: true

# TODO: add when resource is not found on this organization

require 'rails_helper'

RSpec.describe 'Stock' do
  describe 'GET /index' do
    subject(:request) { get '/api/stock', params: {}, headers: }

    let(:json_body) do
      JSON.parse(response.body, symbolize_names: true)
    end

    let(:organization) { create(:organization) }
    let(:user) { create(:user, organization:) }
    let(:product) { create(:product, organization:) }
    let(:product2) { create(:product, organization:) }
    let(:deposit_product1) { DepositProduct.find_by(product:, deposit: organization.default_deposit) }
    let(:deposit_product2) { DepositProduct.find_by(product: product2, deposit: organization.default_deposit) }

    before do
      deposit_product1.update!(quantity: 5)
      deposit_product2.update!(quantity: 2)
    end

    context 'when not logged in' do
      let(:headers) do
        { 'Accept' => 'application/json' }
      end

      it 'returns unauthorized' do
        request

        expect(response).to have_http_status(:unauthorized)
      end
    end

    # rubocop:disable RSpec/MultipleMemoizedHelpers
    context 'when logged in' do
      let(:token) { user.generate_jwt }
      let(:headers) { { 'Authorization' => "Bearer #{token}" } }

      it 'is successful' do
        request
        expect(response).to have_http_status(:success)
      end

      it "lists all user's stocks" do
        request
        expect(json_body[:products]).to match_array(
          [
            {
              id: product.id,
              name: product.name,
              salePrice: product.sale_price,
              balance: deposit_product1.quantity,
              totalSalePrice: product.sale_price * deposit_product1.quantity
            },
            {
              id: product2.id,
              name: product2.name,
              salePrice: product2.sale_price,
              balance: deposit_product2.quantity,
              totalSalePrice: product2.sale_price * deposit_product2.quantity
            }
          ]
        )
      end
    end
  end
end
