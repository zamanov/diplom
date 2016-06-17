class UniversityInfosController < ApplicationController

  # GET /university_infos
  # GET /university_infos.json
  def index
    @university_infos = UniversityInfo.all
  end

  # GET /university_infos/1
  # GET /university_infos/1.json
  def show
    @university_info = UniversityInfo.find(params[:id])
  end
end
