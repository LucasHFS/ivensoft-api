# frozen_string_literal: true

# TODO: add when resource is not found on this organization

require 'rails_helper'

RSpec.describe 'Makes' do
  describe 'GET /index' do
    subject(:request) { get '/api/makes', params: {}, headers: }

    let(:json_body) do
      JSON.parse(response.body, symbolize_names: true)
    end

    let(:user) { create(:user) }

    before do
      create_list(:make, 5, organization: user.organization)
      create_list(:make, 3)
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

      it "lists all user's makes" do
        request
        expect(json_body[:makes].length).to eq(5)
      end
    end
  end

  describe 'POST /create' do
    subject(:request) { post '/api/makes', params:, headers: }

    let(:json_body) do
      JSON.parse(response.body, symbolize_names: true)
    end

    let(:user) { create(:user) }

    let(:params) do
      {
        make: {
          name: 'make a'
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

        it 'creates the make on the db' do
          request

          expect(JSON.parse(response.body).with_indifferent_access).to match(
            {
              make: {
                id: Integer,
                name: 'make a'
              }
            }.with_indifferent_access
          )
        end
      end

      context 'when validation fails' do
        let(:params) do
          {
            make: {
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
    subject(:request) { put "/api/makes/#{make.id}", params:, headers: }

    let(:json_body) do
      JSON.parse(response.body, symbolize_names: true)
    end

    let(:user) { create(:user) }
    let(:make) { create(:make, organization: user.organization) }

    let(:params) do
      {
        make: {
          name: 'make b'
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

        it 'updates the make on the db' do
          request

          updated_make = Make.last.attributes.transform_keys(&:to_sym)

          expect(updated_make).to include(
            {
              name: 'make b'
            }
          )
        end
      end

      context 'when validation fails' do
        let(:params) do
          {
            make: {
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
    subject(:request) { delete "/api/makes/#{make_id}", params: {}, headers: }

    let(:json_body) do
      JSON.parse(response.body, symbolize_names: true)
    end

    let(:user) { create(:user) }
    let!(:make) { create(:make, name: 'make to delete', organization: user.organization) }
    let(:make_id) { make.id }

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

        it 'deletes the make from the db' do
          request

          expect(Make.find_by(name: 'make to delete')).to be_nil
        end
      end

      # context 'when validation fails' do
      #   let!(:product) { create(:product, make:) }

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
        subject(:request) { delete '/api/makes/non-existing', params: {}, headers: }

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
