class CollectionSettingsController < ApplicationController
  before_action :set_collection_setting, only: %i[ show edit update destroy ]
  before_action :require_login

  # GET /collection_settings or /collection_settings.json
  def index
    @collection_settings = CollectionSetting.all
  end

  # GET /collection_settings/1 or /collection_settings/1.json
  def show
  end

  # GET /collection_settings/new
  def new
    @collection_setting = CollectionSetting.new
  end

  # GET /collection_settings/1/edit
  def edit
  end

  # POST /collection_settings or /collection_settings.json
  def create
    @collection_setting = CollectionSetting.new(collection_setting_params)

    respond_to do |format|
      if @collection_setting.save
        format.html { redirect_to collection_setting_url(@collection_setting), notice: "Collection setting was successfully created." }
        format.json { render :show, status: :created, location: @collection_setting }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @collection_setting.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /collection_settings/1 or /collection_settings/1.json
  def update
    respond_to do |format|
      if @collection_setting.update(collection_setting_params)
        format.html { redirect_to collection_setting_url(@collection_setting), notice: "Collection setting was successfully updated." }
        format.json { render :show, status: :ok, location: @collection_setting }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @collection_setting.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /collection_settings/1 or /collection_settings/1.json
  def destroy
    @collection_setting.destroy!

    respond_to do |format|
      format.html { redirect_to collection_settings_url, notice: "Collection setting was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_collection_setting
      @collection_setting = CollectionSetting.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def collection_setting_params
      params.require(:collection_setting).permit(:collection_name, :institution_code, :latest_collection_code, :note, :user_id)
    end
end
