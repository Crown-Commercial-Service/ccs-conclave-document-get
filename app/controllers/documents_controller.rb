class DocumentsController < ApplicationController
  def show
    document = Document.find_by(id: document_params[:id])

    if document.nil?
      render status: :not_found
    elsif document && !document.document_file.file && document.state == 'safe'
      render json: camelize_keys(document), status: :gone
    else
      render json: camelize_keys(document), status: :ok
    end
  end

  private

  def document_params
    params.permit(:id)
  end

  def camelize_keys(document)
    document.as_json(include: {:document_file => :url}).deep_transform_keys! { |key| key.camelize(:lower) }
  end
end
