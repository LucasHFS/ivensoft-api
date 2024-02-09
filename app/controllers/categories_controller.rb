# frozen_string_literal: true

class CategoriesController < ApplicationController
  before_action :authenticate_user!
  before_action :find_category!, only: %i[show update destroy]

  def index
    @categories = current_organization.categories.order(:name)
  end

  def show; end

  def create
    @category = Category.new(category_params)
    @category.organization = current_organization

    if @category.save
      render :show, status: :created
    else
      render json: {
        errors: @category.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  def update
    if @category.update(category_params)
      render :show
    else
      render json: {
        errors: @category.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  def destroy
    if @category.destroy
      render json: {}, status: :no_content
    else
      render json: {
        errors: ['Não foi possivel excluir a categoria']
      }, status: :unprocessable_entity
    end
  end

  private

  def category_params
    params.require(:category).permit(:name, :description)
  end

  def find_category!
    @category = current_organization.categories.find(params[:id])
  end
end
