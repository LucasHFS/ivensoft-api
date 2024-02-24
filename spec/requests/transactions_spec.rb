# frozen_string_literal: true

# TODO: add when resource is not found on this organization

require 'rails_helper'

RSpec.describe 'Transactions' do
  describe 'GET /index' do
    subject(:request) { get '/api/transactions', params: {}, headers: }

    let(:json_body) do
      JSON.parse(response.body, symbolize_names: true)
    end

    let(:organization) { create(:organization) }
    let(:user) { create(:user, organization:) }
    let(:product) { create(:product, organization:) }

    let(:organization2) { create(:organization) }
    let(:product2) { create(:product, organization: organization2) }

    before do
      create_list(:transaction, 5, organization:, product:, deposit: organization.default_deposit)
      create_list(:transaction, 3, organization: organization2, product: product2, deposit: organization2.default_deposit)
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

    context 'when logged in' do
      let(:token) { user.generate_jwt }
      let(:headers) { { 'Authorization' => "Bearer #{token}" } }

      it 'is successful' do
        request
        expect(response).to have_http_status(:success)
      end

      it "lists all user's transactions" do
        request
        expect(json_body[:transactions].length).to eq(5)
      end
    end
  end

  describe 'POST /create' do
    subject(:request) { post '/api/transactions', params:, headers: }

    let(:json_body) do
      JSON.parse(response.body, symbolize_names: true)
    end

    let(:organization) { create(:organization) }
    let(:user) { create(:user, organization:) }

    let(:product1) { create(:product, organization:) }
    let(:product2) { create(:product, organization:) }

    let(:params) do
      {
        transaction: {
          product_transactions: [
            { quantity: 10, transaction_type: 'input', product_id: product1.id, transactioned_at: '2024-02-17 12:00:00' },
            { quantity: 3, transaction_type: 'output', product_id: product2.id, transactioned_at: '2024-02-15 12:00:00' }
          ]
        }
      }
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

    context 'when logged in' do
      let(:token) { user.generate_jwt }
      let(:headers) { { 'Authorization' => "Bearer #{token}" } }

      context 'when successful' do
        it 'is returns :created status' do
          request
          expect(response).to have_http_status(:created)
        end

        it 'creates the first transaction on the db' do
          request

          expect(Transaction.second_to_last.attributes.with_indifferent_access).to include(
            transaction_type: 'input',
            quantity: 10,
            transactioned_at: Time.zone.local(2024, 2, 17, 12, 0, 0),
            deposit_id: organization.default_deposit.id,
            product_id: product1.id
          )
        end

        it 'creates the second transaction on the db' do
          request

          expect(Transaction.last.attributes.with_indifferent_access).to include(
            transaction_type: 'output',
            quantity: 3,
            transactioned_at: Time.zone.local(2024, 2, 15, 12, 0, 0),
            deposit_id: organization.default_deposit.id,
            product_id: product2.id
          )
        end

        it 'updates the product quantity' do
          request

          expect(product1.deposit_products.first.quantity).to eq(10)
          expect(product2.deposit_products.first.quantity).to eq(-3)
        end
      end

      context 'when validation fails' do
        let(:params) do
          {
            transaction: {
              product_transactions: [
                { quantity: 10, transaction_type: 'input', product_id: product1.id },
                { quantity: 3, transaction_type: 'output', product_id: product2.id }
              ]
            }
          }
        end

        it 'is returns :unprocessable_entity status' do
          request
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'returns the error message' do
          request

          expect(JSON.parse(response.body).with_indifferent_access).to match(
            {
              errors: ['param is missing or the value is empty: transactioned_at']
            }.with_indifferent_access
          )
        end
      end
    end
  end
end
