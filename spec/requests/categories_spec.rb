# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Categories' do
  describe 'GET /index' do
    subject(:request) { get '/api/categories', params: {}, headers: }

    let(:json_body) do
      JSON.parse(response.body, symbolize_names: true)
    end

    let(:user) { create(:user) }

    before do
      create_list(:category, 5, organization: user.organization)
      create_list(:category, 3)
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

      it "lists all user's categories" do
        request
        expect(json_body[:categories].length).to eq(5)
      end
    end
  end

  describe 'POST /create' do
    subject(:request) { post '/api/categories', params:, headers: }

    let(:json_body) do
      JSON.parse(response.body, symbolize_names: true)
    end

    let(:user) { create(:user) }

    let(:params) do
      {
        category: {
          name: 'category a',
          description: 'description a'
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

        it 'creates the category on the db' do
          request

          expect(JSON.parse(response.body).with_indifferent_access).to match(
            {
              category: {
                id: Integer,
                name: 'category a',
                description: 'description a'
              }
            }.with_indifferent_access
          )
        end
      end

      context 'when validation fails' do
        let(:params) do
          {
            category: {
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
    subject(:request) { put "/api/categories/#{category.id}", params:, headers: }

    let(:json_body) do
      JSON.parse(response.body, symbolize_names: true)
    end

    let(:user) { create(:user) }
    let(:category) { create(:category, organization: user.organization) }

    let(:params) do
      {
        category: {
          name: 'category b',
          description: 'description b'
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

        it 'creates the category on the db' do
          request

          created_category = Category.last.attributes.transform_keys(&:to_sym)

          expect(created_category).to include(
            {
              name: 'category b',
              description: 'description b'
            }
          )
        end
      end

      context 'when validation fails' do
        let(:params) do
          {
            category: {
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
    subject(:request) { delete "/api/categories/#{category_id}", params: {}, headers: }

    let(:json_body) do
      JSON.parse(response.body, symbolize_names: true)
    end

    let(:user) { create(:user) }
    let!(:category) { create(:category, name: 'category to delete', organization: user.organization) }
    let(:category_id) { category.id }

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

        it 'creates the category on the db' do
          request

          expect(Category.find_by(name: 'category to delete')).to be_nil
        end
      end

      # context 'when validation fails' do
      #   let!(:product) { create(:product, category:) }

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
        subject(:request) { delete '/api/categories/non-existing', params: {}, headers: }

        it 'is returns :unprocessable_entity status' do
          request
          expect(response).to have_http_status(:not_found)
        end

        it 'returns the error message' do
          request

          expect(JSON.parse(response.body).with_indifferent_access).to match(
            {
              errors: ['Recurso não encontrado'],
            }.with_indifferent_access
          )
        end
      end
    end
  end
end
