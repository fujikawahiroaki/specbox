class ToursController < ApplicationController
  include ApplicationHelper
  before_action :set_tour, only: %i[ show edit update destroy ]
  before_action :validate_user, only: %i[ show edit update destroy ]
  before_action :require_login
  before_action :save_and_load_filters
  before_action :save_params_in_session, only: %i[ index ]

  def save_params_in_session
    session[:tours_index_sort] = "" unless session[:tours_index_sort]
    session[:tours_index_direction] = "" unless session[:tours_index_direction]
    session[:tours_index_page] = 1 unless session[:tours_index_page]
    session[:old_ranmemory_tours_index_html] = {} unless session[:old_ranmemory_tours_index_html]

    session[:tours_index_page] = 1 if params[:q].present? && params[:q].empty?.! && params[:q].to_h != session[:old_ranmemory_tours_index_html]

    session[:tours_index_sort] = params[:sort] if params[:sort].present?
    session[:tours_index_direction] = params[:direction] if params[:direction].present?
    session[:tours_index_page] = params[:page] if params[:page].present?
    session[:old_ranmemory_tours_index_html] = session[:ranmemory_tours_index_html]
  end

  # GET /tours or /tours.json
  def index
    @search = Tour.where(user_id: current_user_id).ransack(params[:q])
    @search.sorts = "created_at desc" if @search.sorts.empty?

    if session[:tours_index_sort].present? && session[:tours_index_direction].present?
      @search.sorts.clear
      @search.sorts = [ "#{session[:tours_index_sort]} #{session[:tours_index_direction]}", "created_at desc" ]
    end

    @tours = @search.result.page(session[:tours_index_page])
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
        format.html { redirect_to tours_url_with_ranmemory, notice: t("notice.create") }
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
        format.html { redirect_to tours_url_with_ranmemory, notice: t("notice.update") }
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
      format.html { redirect_to tours_url_with_ranmemory, notice: t("notice.destroy") }
      format.json { head :no_content }
      format.turbo_stream do
        if was_on_show
          redirect_to tours_path(q: session[:ranmemory_tours_index_html]), notice: t("notice.destroy")
        else
          render turbo_stream: turbo_stream.remove(@tour)
        end
      end
    end
  end

  def bulk_update
    bulk_ids = params[:bulk_ids].blank? ? [] : JSON.parse(params[:bulk_ids])
    bulk_columns = params[:bulk_columns].blank? ? [] : JSON.parse(params[:bulk_columns])

    respond_to do |format|
      if bulk_ids.empty?
        format.html { redirect_to tours_url_with_ranmemory, alert: "一括更新対象のデータが選択されていません" }
      elsif bulk_columns.empty?
        format.html { redirect_to tours_url_with_ranmemory, alert: "一括更新対象の項目が選択されていません" }
      else
        bulk_params = {}
        bulk_columns.each do |col|
          bulk_params[col.to_sym] = params[col.to_sym]
        end

        if Tour.where(id: bulk_ids, user_id: current_user_id).update_all(bulk_params)
          format.html { redirect_to tours_url_with_ranmemory, notice: "一括更新に成功しました" }
        else
          format.html { redirect_to tours_url_with_ranmemory, alert: "一括更新に失敗しました" }
        end
      end
    end
  end

  def bulk_delete
    bulk_ids = params[:bulk_ids].blank? ? [] : JSON.parse(params[:bulk_ids])

    respond_to do |format|
      if bulk_ids.empty?
        format.html { redirect_to tours_url_with_ranmemory, alert: "一括削除対象のデータが選択されていません" }
      else
        if Tour.where(id: bulk_ids, user_id: current_user_id).delete_all
          format.html { redirect_to tours_url_with_ranmemory, notice: "一括削除に成功しました" }
        else
          format.html { redirect_to tours_url_with_ranmemory, alert: "一括削除に失敗しました" }
        end
      end
    end
  end

  def set_session_key_identifier
    "tours_index_html"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tour
      @tour = Tour.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def tour_params
      params.require(:tour).permit(:title, :start_date, :end_date, :track, :note, :image1, :image2, :image3, :image4, :image5, :remove_image1, :remove_image2, :remove_image3, :remove_image4, :remove_image5, :bulk_ids, :bulk_columns)
    end

    def validate_user
      unless @tour.user_id == current_user_id
        redirect_to tours_path, notice: "ご指定のIDは存在しません"
      end
    end
end
