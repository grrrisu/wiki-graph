class TermsController < ApplicationController

  def index
  end

  def show
    @term = Term.find_by_name(params[:id])
  end

  def radial
    @term = Term.find_by_name(params[:id])
    render action: 'pechmaria'
  end

  def create
    @term = Term.find_by_name(params[:term][:name])
    redirect_to @term
  end

end
