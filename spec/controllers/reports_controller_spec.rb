require 'rails_helper'

RSpec.describe ReportsController, type: :controller do
  attr_accessor :user, :report

  before do
    @user = FactoryBot.create(:user)
    @report = FactoryBot.create(:report, user: user)
    FactoryBot.create(:document_info, report: report)

    sign_in user
  end

  let(:file) { fixture_file_upload(Rails.root.join('spec/fixtures/sample.xml'), 'application/xml') }

  describe 'GET #index' do
    before do
      get :index
    end

    it 'assigns @reports and renders the index template' do
      expect(assigns(:reports)).to eq([report])
      expect(response).to render_template(:index)
    end
  end

  describe 'GET #new' do
    before do
      get :new
    end

    it 'assigns a new report to @report and renders the new template' do
      expect(assigns(:report)).to be_a_new(Report)
      expect(response).to render_template(:new)
    end
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      before do
        expect { post :create, params: { report: { xml_file: file } } }.to change(Report, :count).by(1)
      end

      it 'creates a new report and enqueues ImportXmlJob' do
        expect(ImportXmlJob.jobs.size).to eq(1)
        expect(ImportXmlJob.jobs.first['args']).to eq([Report.last.id])
      end
    end
  end

  describe 'GET #show' do
    context 'when report is ready' do
      before do
        get :show, params: { id: report.id }
      end

      it 'renders the show template' do
        expect(response).to render_template(:show)
      end
    end
  end

  describe 'POST #import_zip' do
    let(:zip_file) { Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/sample.zip'), 'application/zip') }

    context 'with valid ZIP file' do
      before do
        allow_any_instance_of(Reports::ImportZip).to receive(:execute).and_return(true)
        post :import_zip, params: { zip_file: zip_file }
      end

      it 'redirects to root_path with notice' do
        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to eq('Arquivo ZIP importado com sucesso.')
      end
    end

    context 'with invalid ZIP file' do
      before do
        allow_any_instance_of(Reports::ImportZip).to receive(:execute).and_return(false)
        post :import_zip, params: { zip_file: zip_file }
      end

      it 'redirects to new_report_path with alert' do
        expect(response).to redirect_to(new_report_path)
        expect(flash[:alert]).to eq('Ocorreu um erro ao importar o arquivo ZIP.')
      end
    end
  end
end
