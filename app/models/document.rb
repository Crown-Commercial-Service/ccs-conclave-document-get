class Document < ApplicationRecord
  mount_uploader :document_file, DocumentFileUploader
end
