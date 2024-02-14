# frozen_string_literal: true

class OrganizationsController < ApplicationController
  before_action :authenticate_user!

  def create
    @organization = Organization.new(organization_params)
    @organization.users << current_user

    if @organization.save
      render json: {}, status: :created
    else
      render json: {
        errors: @organization.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  private

  def organization_params
    params.require(:organization).permit(:name)
  end
end
