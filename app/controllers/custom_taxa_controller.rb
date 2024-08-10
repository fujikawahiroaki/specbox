class CustomTaxaController < ApplicationController
  before_action :set_custom_taxon, only: %i[ show edit update destroy ]
  before_action :require_login

  # GET /custom_taxa or /custom_taxa.json
  def index
    @custom_taxa = CustomTaxon.all
  end

  # GET /custom_taxa/1 or /custom_taxa/1.json
  def show
  end

  # GET /custom_taxa/new
  def new
    @custom_taxon = CustomTaxon.new
  end

  # GET /custom_taxa/1/edit
  def edit
  end

  # POST /custom_taxa or /custom_taxa.json
  def create
    @custom_taxon = CustomTaxon.new(custom_taxon_params)

    respond_to do |format|
      if @custom_taxon.save
        format.html { redirect_to custom_taxon_url(@custom_taxon), notice: "Custom taxon was successfully created." }
        format.json { render :show, status: :created, location: @custom_taxon }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @custom_taxon.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /custom_taxa/1 or /custom_taxa/1.json
  def update
    respond_to do |format|
      if @custom_taxon.update(custom_taxon_params)
        format.html { redirect_to custom_taxon_url(@custom_taxon), notice: "Custom taxon was successfully updated." }
        format.json { render :show, status: :ok, location: @custom_taxon }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @custom_taxon.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /custom_taxa/1 or /custom_taxa/1.json
  def destroy
    @custom_taxon.destroy!

    respond_to do |format|
      format.html { redirect_to custom_taxa_url, notice: "Custom taxon was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_custom_taxon
      @custom_taxon = CustomTaxon.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def custom_taxon_params
      params.require(:custom_taxon).permit(:is_private, :user_id)
    end
end
