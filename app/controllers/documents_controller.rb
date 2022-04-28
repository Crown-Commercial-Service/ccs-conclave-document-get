class DocumentsController < ApplicationController
  include Authorize::ClientService
  rescue_from Authorize::ClientService::ApiError, with: :return_error_code
  before_action :validate_client_or_api_key

  def show
    document = Document.find_by(id: document_params[:id])

    if document.nil?
      render status: :not_found
    elsif document && !document.document_file.file && document.state == 'safe'
      document = camelize_keys(document)
      render json: document, status: :gone
    else
      document = camelize_keys(document)
      render json: document, status: :ok
    end
  end

  private

  def document_params
    params.permit(:id)
  end

  def camelize_keys(document)
    document.as_json.transform_keys! { |key| key.camelize(:lower) }
  end

  def return_error_code(code)
    render json: '', status: code.to_s
  end
end
