include ActionController::HttpAuthentication::Basic::ControllerMethods
include ActionController::HttpAuthentication::Token::ControllerMethods

class DocumentsController < ApplicationController
  before_action :authenticate

  def show
    document = Document.find_by_id(document_params[:id])

    if document.nil?
      render status: :not_found
    elsif document && !document.document_file.file && document.state == 'safe'
      render json: document.to_json, status: :gone
    else
      render json: document.to_json, status: :ok
    end
  end

  private

  def document_params
    params.permit(:id)
  end

  def authenticate
    authenticate_or_request_with_http_basic do |source_app, api_key|
      @client = Client.find_by_source_app(source_app)
      @client && @client.api_key == api_key
    end
  end

end
