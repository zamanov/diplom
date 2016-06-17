class DepartmentsController < ApplicationController

  # GET /departments
  # GET /departments.json
  def index
    if params[:university]
      @departments = Department.where(:university => params[:university]).includes(:university).ordering.page(params[:page])
    else
      @departments = Department.includes(:university).ordering.page(params[:page])
    end
  end

  # GET /departments/1
  # GET /departments/1.json
  def show
    @department = Department.includes(:university, branches: [:university], head: [:university], posts: [:placeable, :person]).find(params[:id])
  end
end
