# frozen_string_literal: true

# TODO: add when resource is not found on this organization

require 'rails_helper'

RSpec.describe 'Products' do
  describe 'GET /index' do
    subject(:request) { get '/api/products', params: {}, headers: }

    let(:json_body) do
      JSON.parse(response.body, symbolize_names: true)
    end

    let(:organization) { create(:organization) }
    let(:user) { create(:user, organization:) }

    before do
      create_list(:product, 5, organization:)
      create_list(:product, 3)
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

      it "lists all user's products" do
        request
        expect(json_body[:products].length).to eq(5)
      end
    end
  end

  describe 'POST /create' do
    subject(:request) { post '/api/products', params:, headers: }

    let(:json_body) do
      JSON.parse(response.body, symbolize_names: true)
    end

    let(:organization) { create(:organization) }
    let(:user) { create(:user, organization:) }

    let(:model) { create(:model) }
    let(:category) { create(:category, organization:) }

    let(:params) do
      {
        product: {
          name: 'product a',
          sku: 'product-a-sku',
          model_id: model.id,
          category_id: category.id,
          sale_price: 15.7,
          hide_on_sale: false,
          visible_on_catalog: false,
          comments: 'comments about product a'
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

        it 'creates the product on the db' do
          request

          expect(JSON.parse(response.body).with_indifferent_access).to match(
            {
              product: {
                id: Integer,
                name: 'product a',
                sku: 'product-a-sku',
                makeId: model.make.id,
                modelId: model.id,
                categoryId: category.id,
                salePrice: 15.7,
                hideOnSale: false,
                visibleOnCatalog: false,
                comments: 'comments about product a'
              }
            }.with_indifferent_access
          )
        end

        it 'creates a deposit_product' do
          request

          product = Product.last
          deposit_product = product.deposit_products.last

          expect(deposit_product.deposit).to eq(user.organization.default_deposit)
        end
      end

      context 'when validation fails' do
        let(:params) do
          {
            product: {
              sku: 'product-a-sku',
              model_id: model.id,
              category_id: category.id,
              sale_price_in_cents: 15.7,
              comments: 'comments about product a'
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
              errors: ['Nome não pode ficar em branco']
            }.with_indifferent_access
          )
        end
      end
    end
  end

  describe 'PUT /update' do
    subject(:request) { put "/api/products/#{product.id}", params:, headers: }

    let(:json_body) do
      JSON.parse(response.body, symbolize_names: true)
    end

    let(:organization) { create(:organization) }
    let(:user) { create(:user, organization:) }

    let(:product) { create(:product, organization:) }

    let(:params) do
      {
        product: {
          name: 'product b'
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
        it 'is returns :ok status' do
          request
          expect(response).to have_http_status(:ok)
        end

        it 'updates the product on the db' do
          request

          updated_product = Product.last.attributes.transform_keys(&:to_sym)

          expect(updated_product).to include(
            {
              name: 'product b'
            }
          )
        end
      end

      context 'when validation fails' do
        let(:params) do
          {
            product: {
              name: nil
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
              errors: ['Nome não pode ficar em branco']
            }.with_indifferent_access
          )
        end
      end
    end
  end

  describe 'DELETE /delete' do
    subject(:request) { delete "/api/products/#{product_id}", params: {}, headers: }

    let(:json_body) do
      JSON.parse(response.body, symbolize_names: true)
    end

    let(:organization) { create(:organization) }
    let(:user) { create(:user, organization:) }
    let!(:product) { create(:product, name: 'product to delete', organization:) }
    let(:product_id) { product.id }

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
        it 'is returns :no_content status' do
          request
          expect(response).to have_http_status(:no_content)
        end

        it 'deletes the product from the db' do
          request

          expect(Product.find_by(name: 'product to delete')).to be_nil
        end
      end

      # context 'when validation fails' do
      #   let!(:product) { create(:product, product:) }

      #   it 'is returns :unprocessable_entity status' do
      #     request
      #     expect(response).to have_http_status(:unprocessable_entity)
      #   end

      #   it 'returns the error message' do
      #     request

      #     expect(JSON.parse(response.body).with_indifferent_access).to match(
      #       {
      #         error: {
      #           message: 'Erro de exclusão',
      #           type: 'BadRequest'
      #         }
      #       }.with_indifferent_access
      #     )
      #   end
      # end

      context 'when not found' do
        subject(:request) { delete '/api/products/non-existing', params: {}, headers: }

        it 'is returns :unprocessable_entity status' do
          request
          expect(response).to have_http_status(:not_found)
        end

        it 'returns the error message' do
          request

          expect(JSON.parse(response.body).with_indifferent_access).to match(
            {
              errors: ['Recurso não encontrado']
            }.with_indifferent_access
          )
        end
      end
    end
  end
end
