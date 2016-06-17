class ProgramsController < ApplicationController

  # GET /programs
  # GET /programs.json
  def index
    if params[:university]
      @programs = Program.where(:university => params[:university]).ordering.includes(:university).page(params[:page])
    else
      @programs = Program.ordering.includes(:university).page(params[:page])
    end
  end

  # GET /programs/1
  # GET /programs/1.json
  def show
    @program = Program.includes(:university, documents: [:university]).find(params[:id])
  end

end
