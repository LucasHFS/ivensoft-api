# frozen_string_literal: true

class ModelsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_make!, only: %i[index create update destroy]
  before_action :find_model!, only: %i[show update destroy]

  def index
    @models = @make.models.order(:name)
  end

  def show; end

  def create
    @model = @make.models.build(model_params)
    @model.organization = current_organization

    if @model.save
      render :show, status: :created
    else
      render json: {
        errors: @model.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  def update
    if @model.update(model_params)
      render :show
    else
      render json: {
        errors: @model.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  def destroy
    if @model.destroy
      render json: {}, status: :no_content
    else
      render json: {
        errors: ['Não foi possivel excluir a categoria']
      }, status: :unprocessable_entity
    end
  end

  private

  def model_params
    params.require(:model).permit(:name)
  end

  def find_model!
    @model = @make.models.find(params[:id])
  end

  def find_make!
    @make = current_organization.makes.find(params[:make_id])
  end
end
