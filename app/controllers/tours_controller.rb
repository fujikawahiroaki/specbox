class ToursController < ApplicationController
  before_action :set_tour, only: %i[ show edit update destroy ]
  before_action :require_login

  # GET /tours or /tours.json
  def index
    @tours = Tour.where(user_id: current_user_id).all
  end

  # GET /tours/1 or /tours/1.json
  def show
    Tour.where(user_id: current_user_id).find(params[:id])
  end

  # GET /tours/new
  def new
    @tour = Tour.new
  end

  # GET /tours/1/edit
  def edit
  end

  # POST /tours or /tours.json
  def create
    tour_params[:user_id] = current_user_id
    logger.debug("tour_params!!!!!!!!!!!!!!!!")
    logger.debug(tour_params)
    tour_params_with_user = tour_params
    tour_params_with_user[:user_id] = current_user_id
    logger.debug(tour_params_with_user)
    @tour = Tour.new(tour_params_with_user)

    respond_to do |format|
      if @tour.save
        if params[:tour][:image1].present?
          uploaded_file = params[:tour][:image1]
          image1_id = SecureRandom.uuid.to_s
          image1_path = "image-#{@tour.id}/#{image1_id}#{File.extname(uploaded_file)}"
          image_file_path = Rails.root.join("public", "media", image1_path)
          FileUtils.mkdir_p(File.dirname(image_file_path))
          File.open(file_path, "wb") do |file|
            file.write(uploaded_file.read)
          end
          @tour.update(image1: image1_path)
        end
        format.html { redirect_to tour_url(@tour), notice: "Tour was successfully created." }
        format.json { render :show, status: :created, location: @tour }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @tour.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tours/1 or /tours/1.json
  def update
    respond_to do |format|
      if @tour.update(tour_params)
        format.html { redirect_to tour_url(@tour), notice: "Tour was successfully updated." }
        format.json { render :show, status: :ok, location: @tour }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @tour.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tours/1 or /tours/1.json
  def destroy
    @tour.destroy!

    respond_to do |format|
      format.html { redirect_to tours_url, notice: "Tour was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tour
      @tour = Tour.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def tour_params
      params.require(:tour).permit(:title, :start_date, :end_date, :track, :note, :image1, :image2, :image3, :image4, :image5)
    end
end
