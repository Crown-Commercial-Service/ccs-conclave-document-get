require 'rails_helper'

RSpec.describe "Documents", type: :request do
  let(:client) { create(:client, source_app: 'myapp') }
  let(:document) { create(:document) }

  let(:headers) {{
    "ACCEPT" => "application/json",
    "HTTP_AUTHORIZATION" => ActionController::HttpAuthentication::Basic.encode_credentials(client.source_app, client.api_key)
  }}

  describe 'get' do
    context 'when success' do
      before do
        get "/documents/#{document.id}", headers: headers
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns the Document record' do
        expect(response.body).to eq document.to_json
      end
    end

    context 'when the document has not been processed because something might have gone wrong during the check process' do
      let(:document) { create(:document, document_file: nil, state: 'unprocessed') }

      before do
        get "/documents/#{document.id}", headers: headers
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns the Document record' do
        expect(response.body).to eq document.to_json
      end
    end

    context 'when authentication fails' do
      let(:headers) {{
        "ACCEPT" => "application/json",
        "HTTP_AUTHORIZATION" => ActionController::HttpAuthentication::Basic.encode_credentials('invalid', 'invalid')
      }}

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
          expect(response.body).to eq document.to_json
        end
      end

      context 'when the document file is unsafe' do
        let(:document) { create(:document, document_file: nil, state: 'unsafe') }

        before do
          get "/documents/#{document.id}", headers: headers
        end

        it 'returns status code 410' do
          expect(response).to have_http_status(200)
        end

        it 'returns the Document record' do
          expect(response.body).to eq document.to_json
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
        expect(response.body).to eq document.to_json
      end
    end

    context 'when Document cannot be found' do
      it 'returns status code 404' do
        get "/documents/invalid", headers: headers
        expect(response).to have_http_status(404)
      end
    end
  end
end
