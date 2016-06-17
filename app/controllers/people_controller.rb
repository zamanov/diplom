class PeopleController < ApplicationController
  # GET /people
  def index
    @people = Person.ordering.page(params[:page])
  end

  # GET /people/1
  def show
    @person = Person.find(params[:id])
  end
end
