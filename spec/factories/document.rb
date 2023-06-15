FactoryBot.define do
  factory :document do
    source_app { 'myapp' }
    document_file { Rack::Test::UploadedFile.new('spec/fixtures/test_pdf.pdf', 'application/pdf') }
  end
end
