require 'rails_helper'

RSpec.describe 'Documents', type: :request do
  let(:client) { create(:client, source_app: 'myapp') }
  let(:clientid) { ENV['CLIENT_ID'] }
  let(:jwt_token) { JWT.encode({ aud: ENV['CLIENT_ID'] }, 'test') }
  let(:document) { create(:document) }

  let(:headers) do
    {
      'ACCEPT' => 'application/json',
      'x-api-key' => client.api_key,
      'Authorization' => "Bearer #{jwt_token}"
    }
  end

  describe 'get' do
    before do
      stub_request(:post, "http://www.test.com/security/tokens/validation?client-id=#{clientid}")
        .with(
          headers: {
            'Accept' => '*/*',
            'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'Authorization' => "Bearer #{jwt_token}",
            'Content-Type' => 'application/x-www-form-urlencoded',
            'User-Agent' => 'Ruby'
          }
        )
        .to_return(status: 200, body: 'true', headers: {})
    end

    context 'when success' do
      let(:document) { create(:document, document_file: document_file) }

      context 'when pdf file' do
        let(:document_file) { fixture_file_upload 'spec/fixtures/test_pdf.pdf', 'application/pdf' }
        before do
          get "/documents/#{document.id}", headers: headers
        end

        it 'returns status code 200' do
          expect(response).to have_http_status(200)
        end

        it 'returns the Document record' do
          expect(response.body).to have_the_same_attributes_as(document)
        end
      end

      context 'when csv file' do
        let(:document_file) { fixture_file_upload('test_csv.csv', 'text/csv') }
        before do
          get "/documents/#{document.id}", headers: headers
        end

        it 'returns status code 200' do
          expect(response).to have_http_status(200)
        end

        it 'returns the Document record' do
          expect(response.body).to have_the_same_attributes_as(document)
        end
      end

      context 'when xslx file' do
        let(:document_file) do
          fixture_file_upload('test_xlsx.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet')
        end
        before do
          get "/documents/#{document.id}", headers: headers
        end

        it 'returns status code 200' do
          expect(response).to have_http_status(200)
        end

        it 'returns the Document record' do
          expect(response.body).to have_the_same_attributes_as(document)
        end
      end

      context 'when docx file' do
        let(:document_file) { fixture_file_upload('test_docx.docx', 'text/docx') }
        before do
          get "/documents/#{document.id}", headers: headers
        end

        it 'returns status code 200' do
          expect(response).to have_http_status(200)
        end

        it 'returns the Document record' do
          expect(response.body).to have_the_same_attributes_as(document)
        end
      end
    end

    context 'when the document has not been processed because something may have gone wrong during the check process' do
      let(:document) { create(:document, document_file: nil, state: 'unprocessed') }

      before do
        get "/documents/#{document.id}", headers: headers
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns the Document record' do
        expect(response.body).to have_the_same_attributes_as(document)
      end
    end

    context 'when authentication fails' do
      let(:headers) do
        {
          'ACCEPT' => 'application/json',
          'HTTP_AUTHORIZATION' => ActionController::HttpAuthentication::Basic.encode_credentials('invalid', 'invalid')
        }
      end

      it 'returns status code 401' do
        get "/documents/#{document.id}", headers: headers
        expect(response).to have_http_status(401)
      end
    end

    context 'when file has been deleted' do
      context 'when the document is safe' do
        let(:document) { create(:document, document_file: nil, state: 'safe') }

        before do
          get "/documents/#{document.id}", headers: headers
        end

        it 'returns status code 410' do
          expect(response).to have_http_status(410)
        end

        it 'returns the Document record' do
          expect(response.body).to have_the_same_attributes_as(document)
        end
      end

      context 'when the document file is unsafe' do
        let(:document) { create(:document, document_file: nil, state: 'unsafe') }

        before do
          get "/documents/#{document.id}", headers: headers
        end

        it 'returns status code 200' do
          expect(response).to have_http_status(200)
        end

        it 'returns the Document record' do
          expect(response.body).to have_the_same_attributes_as(document)
        end
      end
    end

    context 'when the document is still processing' do
      let(:document) { create(:document, document_file: nil, state: 'processing') }

      before do
        get "/documents/#{document.id}", headers: headers
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns the Document record' do
        expect(response.body).to have_the_same_attributes_as(document)
      end
    end

    context 'when Document cannot be found' do
      it 'returns status code 404' do
        get '/documents/invalid', headers: headers
        expect(response).to have_http_status(404)
      end
    end
  end
end
