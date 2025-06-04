class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :record_invalid
  rescue_from StandardError, with: :standard_error
  
  private
  
  def record_not_found(error)
    render json: { error: error.message }, status: :not_found
  end
  
  def record_invalid(error)
    render json: { error: error.record.errors.full_messages.join(', ') }, status: :unprocessable_entity
  end
  
  def standard_error(error)
    render json: { error: error.message }, status: :internal_server_error
  end
end
