class TermsController < ApplicationController

  def index
  end

  def show
    @term = Term.find(params[:id])
  end

  def create
    @term = Term.find_by_name(params[:term][:name])
    redirect_to @term
  end

end
