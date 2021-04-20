class DocumentsController < ApplicationController
  def show
    document = Document.find_by(id: document_params[:id])

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
end
