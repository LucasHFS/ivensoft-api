# frozen_string_literal: true

class VehiclesController < ApplicationController
  before_action :authenticate_user!
  before_action :find_vehicle!, only: %i[show update destroy]

  def index
    @vehicles = current_organization.vehicles.includes(:vehicle_products)
  end

  def show; end

  def create
    ActiveRecord::Base.transaction do
      vehicle = Vehicle.create!(vehicle_attributes.except(:vehicle_products))

      vehicle_attributes[:vehicle_products].each do |product_vehicle|
        VehicleProduct.create!(
          quantity: product_vehicle[:quantity],
          vehicle:,
          product_id: product_vehicle[:product_id]
        )
      end
    end

    render json: {}, status: :created
  rescue ActiveRecord::RecordInvalid => e
    render json: {
      errors: e.record.errors.full_messages
    }, status: :unprocessable_entity
  end

  # rubocop:disable Metrics/MethodLength
  def update
    vehicle = Vehicle.find(params[:id])

    ActiveRecord::Base.transaction do
      vehicle.update!(vehicle_attributes.except(:vehicle_products))
      vehicle.vehicle_products.destroy_all
      vehicle_attributes[:vehicle_products].each do |product_vehicle|
        VehicleProduct.create!(
          quantity: product_vehicle[:quantity],
          vehicle:,
          product_id: product_vehicle[:product_id]
        )
      end
    end

    render json: {}, status: :ok
  rescue ActiveRecord::RecordInvalid => e
    render json: {
      errors: e.record.errors.full_messages
    }, status: :unprocessable_entity
  rescue ActiveRecord::RecordNotFound => e
    render json: {
      error: 'Vehicle not found'
    }, status: :not_found
  end

  def destroy
    if @vehicle.destroy
      render json: {}, status: :no_content
    else
      render json: { errors: @vehicle.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def vehicle_params
    params.require(:vehicle).permit(
      :id,
      :plate,
      :comments,
      :model_id,
      vehicle_products: %i[id product_id quantity _destroy]
    )
  end

  def vehicle_attributes
    raise ActionController::ParameterMissing, :plate if vehicle_params[:plate].blank?
    raise ActionController::ParameterMissing, :model_id if vehicle_params[:model_id].blank?

    vehicle_params.merge(organization: current_organization)
  end

  def find_vehicle!
    @vehicle = current_organization.vehicles.find(params[:id])
  end
end
