# frozen_string_literal: true

# TODO: add when resource is not found on this organization

require 'rails_helper'

RSpec.describe 'Vehicles' do
  describe 'GET /index' do
    subject(:request) { get '/api/vehicles', params: {}, headers: }

    let(:json_body) do
      JSON.parse(response.body, symbolize_names: true)
    end

    let(:organization) { create(:organization) }
    let(:user) { create(:user, organization:) }
    let(:product) { create(:product, :with_deposit_products, organization:) }
    let(:product2) { create(:product, :with_deposit_products, organization:) }

    let(:model) { create(:model, organization:) }
    let(:vehicle) { create(:vehicle, organization:, model:) }

    before do
      vehicle.vehicle_products.create!(product_id: product.id, quantity: 5)
      vehicle.vehicle_products.create!(product_id: product2.id, quantity: 7)
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

      it "lists all user's vehicles" do
        request

        expect(json_body[:vehicles]).to eq(
          [
            {
              id: vehicle.id,
              plate: vehicle.plate,
              comments: vehicle.comments,
              modelId: model.id,
              makeId: model.make_id,
              vehicle_products: [
                { product_id: product.id, name: vehicle.vehicle_products.first.product.name, quantity: 5 },
                { product_id: product2.id, name: vehicle.vehicle_products.last.product.name, quantity: 7 }
              ]
            }
          ]
        )
      end
    end
  end

  describe 'GET /show' do
    subject(:request) { get "/api/vehicles/#{vehicle.id}", params: {}, headers: }

    let(:json_body) do
      JSON.parse(response.body, symbolize_names: true)
    end

    let(:organization) { create(:organization) }
    let(:user) { create(:user, organization:) }
    let(:product) { create(:product, :with_deposit_products, organization:) }
    let(:product2) { create(:product, :with_deposit_products, organization:) }

    let(:model) { create(:model, organization:) }
    let(:vehicle) { create(:vehicle, organization:, model:) }

    before do
      vehicle.vehicle_products.create!(product_id: product.id, quantity: 5)
      vehicle.vehicle_products.create!(product_id: product2.id, quantity: 7)
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

      it "lists all user's vehicles" do
        request

        expect(json_body[:vehicle]).to eq(
          {
            id: vehicle.id,
            plate: vehicle.plate,
            comments: vehicle.comments,
            modelId: model.id,
            makeId: model.make_id,
            vehicle_products: [
              { product_id: product.id, name: vehicle.vehicle_products.first.product.name, quantity: 5 },
              { product_id: product2.id, name: vehicle.vehicle_products.last.product.name, quantity: 7 }
            ]
          }
        )
      end
    end
  end

  describe 'POST /create' do
    subject(:request) { post '/api/vehicles', params:, headers: }

    let(:json_body) do
      JSON.parse(response.body, symbolize_names: true)
    end

    let(:organization) { create(:organization) }
    let(:user) { create(:user, organization:) }

    let(:product1) { create(:product, :with_deposit_products, organization:) }
    let(:product2) { create(:product, :with_deposit_products, organization:) }

    let(:model) { create(:model, organization:) }

    let(:params) do
      {
        vehicle: {
          plate: 'ABC1234',
          comments: 'Some comments here',
          model_id: model.id,
          vehicle_products: [
            { quantity: 10, product_id: product1.id },
            { quantity: 3, product_id: product2.id }
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

        it 'creates a new vehicle with right attributes' do
          request

          vehicle = Vehicle.last
          expect(vehicle.attributes.with_indifferent_access).to include(
            plate: 'ABC1234',
            comments: 'Some comments here',
            model_id: model.id,
            organization_id: organization.id
          )
        end

        # rubocop:disable RSpec/MultipleExpectations
        it 'creates the vehicle_products' do
          request

          vehicle = Vehicle.last
          expect(vehicle.vehicle_products.length).to eq(2)

          vehicle_product1 = vehicle.vehicle_products.find_by(product_id: product1.id)
          expect(vehicle_product1.attributes.with_indifferent_access).to include(
            quantity: 10,
            vehicle_id: vehicle.id,
            product_id: product1.id
          )

          vehicle_product2 = vehicle.vehicle_products.find_by(product_id: product2.id)
          expect(vehicle_product2.attributes.with_indifferent_access).to include(
            quantity: 3,
            vehicle_id: vehicle.id,
            product_id: product2.id
          )
        end
      end

      context 'when validation fails' do
        let(:params) do
          {
            vehicle: {
              comments: 'Some comments here',
              model_id: model.id,
              vehicle_products: [
                { quantity: 10, product_id: product1.id },
                { quantity: 3, product_id: product2.id }
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
              errors: ['param is missing or the value is empty: plate']
            }.with_indifferent_access
          )
        end
      end
    end
  end

  describe 'PUT /update' do
    subject(:request) { put "/api/vehicles/#{vehicle.id}", params:, headers: }

    let(:json_body) do
      JSON.parse(response.body, symbolize_names: true)
    end

    let(:organization) { create(:organization) }
    let(:user) { create(:user, organization:) }

    let(:product1) { create(:product, :with_deposit_products, organization:) }
    let(:product2) { create(:product, :with_deposit_products, organization:) }
    let(:product3) { create(:product, :with_deposit_products, organization:) } # New product for update

    let(:vehicle) do
      create(:vehicle, organization:, plate: 'OLD123', model: create(:model, organization:))
    end

    let(:new_model) { create(:model, organization:)}

    let!(:vehicle_product1) { create(:vehicle_product, vehicle:, product: product1, quantity: 5) }
    let!(:vehicle_product2) { create(:vehicle_product, vehicle:, product: product2, quantity: 2) }

    let(:params) do
      {
        vehicle: {
          plate: 'NEW1234', # Updated attribute
          model_id: new_model.id,
          vehicle_products: [
            { id: vehicle_product1.id, quantity: 10 }, # Updated quantity
            { id: nil, product_id: product3.id, quantity: 4 },  # New vehicle product
            { id: vehicle_product2.id, _destroy: true} # Remove vehicle product
          ]
        }
      }
    end

    context 'when not logged in' do
      let(:headers) { { 'Accept' => 'application/json' } }

      it 'returns unauthorized' do
        request
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when logged in' do
      let(:token) { user.generate_jwt }
      let(:headers) { { 'Authorization' => "Bearer #{token}" } }

      context 'when successful' do
        it 'returns :ok status' do
          request
          expect(response).to have_http_status(:ok)
        end

        it 'updates the vehicle attributes correctly' do
          request
          vehicle.reload
          expect(vehicle.plate).to eq('NEW1234')
        end

        it 'updates the existing vehicle_product quantity' do
          request
          vehicle_product1.reload
          expect(vehicle_product1.quantity).to eq(10)
        end

        it 'adds a new vehicle_product' do
          request
          new_vehicle_product = VehicleProduct.find_by(product_id: product3.id)
          expect(new_vehicle_product.quantity).to eq(4)
        end

        it 'removes the specified vehicle_product' do
          request
          expect { vehicle_product2.reload }.to raise_error(ActiveRecord::RecordNotFound)
        end

        it 'updates model and make' do
          request

          vehicle.reload
          expect(vehicle.model_id).to eq(new_model.id)
          expect(vehicle.model.make_id).to eq(new_model.make_id)
        end
      end

      context 'when validation fails' do
        let(:params) do
          {
            vehicle: {
              plate: '' # Invalid plate value
            }
          }
        end

        it 'returns :unprocessable_entity status' do
          request
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'does not update the vehicle' do
          original_plate = vehicle.plate
          request
          vehicle.reload
          expect(vehicle.plate).to eq(original_plate)
        end

        it 'returns the error message' do
          request
          expect(json_body).to match(
            {
              errors: ['param is missing or the value is empty: plate']
            }
          )
        end
      end
    end
  end

  describe 'DELETE /delete' do
    subject(:request) { delete "/api/vehicles/#{vehicle_id}", params: {}, headers: }

    let(:json_body) do
      JSON.parse(response.body, symbolize_names: true)
    end

    let(:organization) { create(:organization) }
    let(:user) { create(:user, organization:) }
    let!(:vehicle) { create(:vehicle, organization:) }
    let(:vehicle_id) { vehicle.id }

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

        it 'deletes the vehicle from the db' do
          request

          expect(Product.find_by(name: 'vehicle to delete')).to be_nil
        end
      end

      # context 'when validation fails' do
      #   let!(:vehicle) { create(:vehicle, vehicle:) }

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
        subject(:request) { delete '/api/vehicles/non-existing', params: {}, headers: }

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
