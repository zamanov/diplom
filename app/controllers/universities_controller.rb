class UniversitiesController < ApplicationController

  # GET /universities
  # GET /universities.json
  def index
    @universities = University.page(params[:page])
  end

  # GET /universities/1
  # GET /universities/1.json
  def show
    @university = University.find(params[:id])
    @university_info = UniversityInfo.where(:university => @university, :version => @university.current_version).first
    @leaders = @university.posts.where(:is_manage => true, :person => Person.where(:version => @university.current_version)).includes(:placeable, :person)
  end

end
