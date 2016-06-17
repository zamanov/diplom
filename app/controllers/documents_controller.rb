class DocumentsController < ApplicationController
  before_action :set_document, only: [:show, :download]

  # GET /documents
  # GET /documents.json
  def index
    if params[:university]
      @documents = Document.where(:university => params[:university]).ordering.includes(:university, :program).page(params[:page])
    else
      @documents = Document.ordering.includes(:university, :program).page(params[:page])
    end
  end

  # GET /documents/1
  # GET /documents/1.json
  def show
  end

  def download
    send_file @document.file.path,
    :filename => "#{@document.code}.#{@document.file_ext}",
    :type => @document.file_content_type,
    :disposition => 'attachment'
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_document
    @document = Document.find(params[:id])
  end
end
