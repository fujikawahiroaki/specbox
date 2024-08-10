class SpecimensController < ApplicationController
  before_action :set_specimen, only: %i[ show edit update destroy ]
  before_action :require_login

  # GET /specimens or /specimens.json
  def index
    @specimens = Specimen.all
  end

  # GET /specimens/1 or /specimens/1.json
  def show
  end

  # GET /specimens/new
  def new
    @specimen = Specimen.new
  end

  # GET /specimens/1/edit
  def edit
  end

  # POST /specimens or /specimens.json
  def create
    @specimen = Specimen.new(specimen_params)

    respond_to do |format|
      if @specimen.save
        format.html { redirect_to specimen_url(@specimen), notice: "Specimen was successfully created." }
        format.json { render :show, status: :created, location: @specimen }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @specimen.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /specimens/1 or /specimens/1.json
  def update
    respond_to do |format|
      if @specimen.update(specimen_params)
        format.html { redirect_to specimen_url(@specimen), notice: "Specimen was successfully updated." }
        format.json { render :show, status: :ok, location: @specimen }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @specimen.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /specimens/1 or /specimens/1.json
  def destroy
    @specimen.destroy!

    respond_to do |format|
      format.html { redirect_to specimens_url, notice: "Specimen was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_specimen
      @specimen = Specimen.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def specimen_params
      params.require(:specimen).permit(:date_last_modified, :collection_code, :identified_by, :date_identified, :collecter, :year, :month, :day, :sex, :preparation_type, :disposition, :sampling_protocol, :sampling_effort, :lifestage, :establishment_means, :rights, :note, :image1, :image2, :image3, :image4, :image5, :collect_point_info_id, :collection_settings_info_id, :custom_taxon_info_id, :default_taxon_info_id, :tour_id, :user_id, :allow_kojin_shuzo, :published_kojin_shuzo)
    end
end
