class CollectPointsController < ApplicationController
  before_action :set_collect_point, only: %i[ show edit update destroy ]
  before_action :require_login

  # GET /collect_points or /collect_points.json
  def index
    @collect_points = CollectPoint.all
  end

  # GET /collect_points/1 or /collect_points/1.json
  def show
  end

  # GET /collect_points/new
  def new
    @collect_point = CollectPoint.new
  end

  # GET /collect_points/1/edit
  def edit
  end

  # POST /collect_points or /collect_points.json
  def create
    collect_point_params[:user_id] = current_user_id
    @collect_point = CollectPoint.new(collect_point_params)

    respond_to do |format|
      if @collect_point.save
        format.html { redirect_to collect_point_url(@collect_point), notice: "Collect point was successfully created." }
        format.json { render :show, status: :created, location: @collect_point }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @collect_point.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /collect_points/1 or /collect_points/1.json
  def update
    respond_to do |format|
      if @collect_point.update(collect_point_params)
        format.html { redirect_to collect_point_url(@collect_point), notice: "Collect point was successfully updated." }
        format.json { render :show, status: :ok, location: @collect_point }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @collect_point.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /collect_points/1 or /collect_points/1.json
  def destroy
    @collect_point.destroy!

    respond_to do |format|
      format.html { redirect_to collect_points_url, notice: "Collect point was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_collect_point
      @collect_point = CollectPoint.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def collect_point_params
      params.require(:collect_point).permit(:contient, :island_group, :island, :country, :state_provice, :county, :municipality, :verbatim_locality, :japanese_place_name, :japanese_place_name_detail, :coordinate_precision, :location, :minimum_elevation, :maximum_elevation, :minimum_depth, :maximum_depth, :note, :image1, :image2, :image3, :image4, :image5)
    end
end
