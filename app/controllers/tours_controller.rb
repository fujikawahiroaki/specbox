class ToursController < ApplicationController
  before_action :set_tour, only: %i[ show edit update destroy ]
  before_action :require_login

  # GET /tours or /tours.json
  def list
    session[:visible_columns] ||= default_visible_columns
    @visible_columns = session[:visible_columns]

    @search = Tour.ransack(params[:q])
    @search.sorts = "created_at desc" if @search.sorts.empty?

    if params[:sort].present? && params[:direction].present?
      @tours = Tour.order("#{params[:sort]} #{params[:direction]}").page(params[:page])
    else
      @tours = @search.result.page(params[:page])
    end
  end

  def index
    list
  end

  # GET /tours/1 or /tours/1.json
  def show
    Tour.where(user_id: current_user_id).find(params[:id])
    respond_to do |format|
      format.html
      format.turbo_stream
    end
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
    tour_params_with_user = tour_params
    tour_params_with_user[:user_id] = current_user_id
    @tour = Tour.new(tour_params_with_user)

    respond_to do |format|
      if @tour.save
        format.html { redirect_to tours_url, notice: t("notice.create") }
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
        format.html { redirect_to tours_url, notice: t("notice.update") }
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
    # 削除前にリファラーを確認して分岐
    was_on_show = request.referer&.include?("/tours/#{@tour.id}")

    respond_to do |format|
      format.html { redirect_to tours_url, notice: t("notice.destroy") }
      format.json { head :no_content }
      format.turbo_stream do
        if was_on_show
          redirect_to tours_path, notice: t("notice.destroy")
        else
          render turbo_stream: turbo_stream.remove(@tour)
        end
      end
    end
  end

  def default_visible_columns
    %w[title start_date end_date]
  end

  def update_columns
    session[:visible_columns] = params[:columns] || []
    @visible_columns = session[:visible_columns] # 更新後のカラムを再設定
    list
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.update("tour_table", partial: "tours/table", locals: { tours: @tours, visible_columns: @visible_columns })
      end
    end
  end

  def set_session_key_identifier
    "tours_index_html" if action_name == "update_columns"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tour
      @tour = Tour.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def tour_params
      params.require(:tour).permit(:title, :start_date, :end_date, :track, :note, :image1, :image2, :image3, :image4, :image5, :remove_image1, :remove_image2, :remove_image3, :remove_image4, :remove_image5)
    end
end
