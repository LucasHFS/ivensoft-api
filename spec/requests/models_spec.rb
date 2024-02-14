# frozen_string_literal: true

# TODO: add when resource is not found on this organization

require 'rails_helper'

RSpec.describe 'Model' do
  describe 'GET /index' do
    subject(:request) { get "/api/makes/#{volkswagen.id}/models", headers: }

    let(:json_body) do
      JSON.parse(response.body, symbolize_names: true)
    end

    let(:user) { create(:user) }
    let(:params) { {} }

    let(:volkswagen) { create(:make, name: 'Volkswagen', organization: user.organization) }

    before do
      create_list(:model, 5, organization: user.organization, make: volkswagen)
      create_list(:model, 3)
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

      it "lists all user's models" do
        request
        expect(json_body[:models].length).to eq(5)
      end
    end
  end

  describe 'POST /create' do
    subject(:request) { post "/api/makes/#{volkswagen.id}/models", params:, headers: }

    let(:volkswagen) { create(:make, name: 'Volkswagen', organization: user.organization) }

    let(:json_body) do
      JSON.parse(response.body, symbolize_names: true)
    end

    let(:user) { create(:user) }

    let(:params) do
      {
        model: {
          name: 'model a'
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

        it 'creates the model on the db' do
          request

          expect(JSON.parse(response.body).with_indifferent_access).to match(
            {
              model: {
                id: Integer,
                name: 'model a'
              }
            }.with_indifferent_access
          )
        end
      end

      context 'when validation fails' do
        let(:params) do
          {
            model: {
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

  describe 'PUT /update' do
    subject(:request) { put "/api/makes/#{volkswagen.id}/models/#{model.id}", params:, headers: }

    let(:volkswagen) { create(:make, name: 'Volkswagen', organization: user.organization) }

    let(:json_body) do
      JSON.parse(response.body, symbolize_names: true)
    end

    let(:user) { create(:user) }
    let(:model) { create(:model, organization: user.organization, make: volkswagen) }

    let(:params) do
      {
        model: {
          name: 'model b'
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

        it 'updates the model on the db' do
          request

          updated_model = Model.last.attributes.transform_keys(&:to_sym)

          expect(updated_model).to include(
            {
              name: 'model b'
            }
          )
        end
      end

      context 'when validation fails' do
        let(:params) do
          {
            model: {
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
    subject(:request) { delete "/api/makes/#{volkswagen.id}/models/#{model.id}", params: {}, headers: }

    let(:volkswagen) { create(:make, name: 'Volkswagen', organization: user.organization) }

    let(:json_body) do
      JSON.parse(response.body, symbolize_names: true)
    end

    let(:user) { create(:user) }
    let!(:model) { create(:model, name: 'model to delete', organization: user.organization, make: volkswagen) }

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

        it 'deletes the model from the db' do
          request

          expect(Model.find_by(name: 'model to delete')).to be_nil
        end
      end

      # context 'when validation fails' do
      #   let!(:product) { create(:product, model:) }

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
        subject(:request) { delete "/api/makes/#{volkswagen.id}/models/non-existing", params: {}, headers: }

        let(:volkswagen) { create(:make, name: 'Volkswagen', organization: user.organization) }

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
