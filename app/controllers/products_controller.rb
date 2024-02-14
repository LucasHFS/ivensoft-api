# frozen_string_literal: true

class ProductsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_product!, only: %i[show update destroy]

  def index
    @products = current_organization.products.order(:name)
  end

  def show; end

  def create
    @product = current_organization.products.build(product_attributes)

    if @product.save
      render :show, status: :created
    else
      render json: { errors: @product.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @product.update(product_attributes)
      render :show
    else
      render json: { errors: @product.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    if @product.destroy
      render json: {}, status: :no_content
    else
      render json: { errors: @product.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def find_product!
    @product = current_organization.products.find(params[:id])
  end

  def product_params
    params.require(:product).permit(
      :name,
      :sku,
      :model_id,
      :category_id,
      :sale_price_in_cents,
      :hide_on_sale,
      :visible_on_catalog,
      :comments
    )
  end

  def product_attributes
    product_params.merge(
      organization_id: current_organization.id,
      sale_price_in_cents: (product_params[:sale_price_in_cents].to_f * 100).to_i
    )
  end
end
