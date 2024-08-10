class SpecimenLabelsController < ApplicationController
  before_action :set_specimen_label, only: %i[ show edit update destroy ]
  before_action :require_login

  # GET /specimen_labels or /specimen_labels.json
  def index
    @specimen_labels = SpecimenLabel.all
  end

  # GET /specimen_labels/1 or /specimen_labels/1.json
  def show
  end

  # GET /specimen_labels/new
  def new
    @specimen_label = SpecimenLabel.new
  end

  # GET /specimen_labels/1/edit
  def edit
  end

  # POST /specimen_labels or /specimen_labels.json
  def create
    @specimen_label = SpecimenLabel.new(specimen_label_params)

    respond_to do |format|
      if @specimen_label.save
        format.html { redirect_to specimen_label_url(@specimen_label), notice: "Specimen label was successfully created." }
        format.json { render :show, status: :created, location: @specimen_label }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @specimen_label.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /specimen_labels/1 or /specimen_labels/1.json
  def update
    respond_to do |format|
      if @specimen_label.update(specimen_label_params)
        format.html { redirect_to specimen_label_url(@specimen_label), notice: "Specimen label was successfully updated." }
        format.json { render :show, status: :ok, location: @specimen_label }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @specimen_label.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /specimen_labels/1 or /specimen_labels/1.json
  def destroy
    @specimen_label.destroy!

    respond_to do |format|
      format.html { redirect_to specimen_labels_url, notice: "Specimen label was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_specimen_label
      @specimen_label = SpecimenLabel.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def specimen_label_params
      params.require(:specimen_label).permit(:name, :data_label_flag, :coll_label_flag, :det_label_flag, :note_label_flag, :user_id)
    end
end
