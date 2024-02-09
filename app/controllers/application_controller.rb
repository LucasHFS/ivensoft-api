# frozen_string_literal: true

class ApplicationController < ActionController::API
  respond_to :json
  include ActionController::MimeResponds

  def current_organization
    current_user.organization
  end

  rescue_from ActionController::ParameterMissing, with: :missing_parameters
  rescue_from ActiveRecord::RecordInvalid, with: :record_invalid
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActiveRecord::InvalidForeignKey, with: :invalid_foreign_key

  def missing_parameters(exception)
    respond_with_error(
      status: :unprocessable_entity,
      message: exception.message
    )
  end

  def record_invalid(exception)
    respond_with_error(
      status: :conflict,
      message: exception.record.errors.full_messages
    )
  end

  def record_not_found
    respond_with_error(
      status: :not_found,
      message: 'Recurso não encontrado'
    )
  end

  def invalid_foreign_key
    respond_with_error(
      status: :unprocessable_entity,
      message: 'Erro de exclusão'
    )
  end

  def respond_with_error(status:, message:)
    response = { errors: [message].flatten }
    render json: response, status:
  end
end
