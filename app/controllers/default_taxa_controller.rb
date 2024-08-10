class DefaultTaxaController < ApplicationController
  before_action :set_default_taxon, only: %i[ show edit update destroy ]
  before_action :require_login

  # GET /default_taxa or /default_taxa.json
  def index
    @default_taxa = DefaultTaxon.all
  end

  # GET /default_taxa/1 or /default_taxa/1.json
  def show
  end

  # GET /default_taxa/new
  def new
    @default_taxon = DefaultTaxon.new
  end

  # GET /default_taxa/1/edit
  def edit
  end

  # POST /default_taxa or /default_taxa.json
  def create
    @default_taxon = DefaultTaxon.new(default_taxon_params)

    respond_to do |format|
      if @default_taxon.save
        format.html { redirect_to default_taxon_url(@default_taxon), notice: "Default taxon was successfully created." }
        format.json { render :show, status: :created, location: @default_taxon }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @default_taxon.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /default_taxa/1 or /default_taxa/1.json
  def update
    respond_to do |format|
      if @default_taxon.update(default_taxon_params)
        format.html { redirect_to default_taxon_url(@default_taxon), notice: "Default taxon was successfully updated." }
        format.json { render :show, status: :ok, location: @default_taxon }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @default_taxon.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /default_taxa/1 or /default_taxa/1.json
  def destroy
    @default_taxon.destroy!

    respond_to do |format|
      format.html { redirect_to default_taxa_url, notice: "Default taxon was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_default_taxon
      @default_taxon = DefaultTaxon.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def default_taxon_params
      params.require(:default_taxon).permit(:is_private)
    end
end
