require 'rails_helper'
require 'carrierwave/test/matchers'

RSpec.describe 'DocumentFileUploader' do
  include CarrierWave::Test::Matchers

  let(:document) { create(:document) }
  let(:uploader) { DocumentFileUploader.new(document) }
  let(:development_store_dir_path) do
    "ccs-conclave-document-upload/public/uploads/document/document_file/#{document.id}/test_pdf.pdf"
  end

  context 'in development environment' do
    it 'finds the directory where uploaded files are stored' do
      allow(Rails).to receive(:env).and_return(ActiveSupport::StringInquirer.new('development'))

      expect(document.document_file.current_path).to include(development_store_dir_path)
    end
  end
end
