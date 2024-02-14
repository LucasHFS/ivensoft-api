# frozen_string_literal: true

class MakesController < ApplicationController
  before_action :authenticate_user!
  before_action :find_make!, only: %i[show update destroy]

  def index
    @makes = current_organization.makes.order(:name)
  end

  def show; end

  def create
    @make = Make.new(make_params)
    @make.organization = current_organization

    if @make.save
      render :show, status: :created
    else
      render json: {
        errors: @make.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  def update
    if @make.update(make_params)
      render :show
    else
      render json: {
        errors: @make.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  def destroy
    if @make.destroy
      render json: {}, status: :no_content
    else
      render json: {
        errors: ['Não foi possivel excluir a categoria']
      }, status: :unprocessable_entity
    end
  end

  private

  def make_params
    params.require(:make).permit(:name)
  end

  def find_make!
    @make = current_organization.makes.find(params[:id])
  end
end
