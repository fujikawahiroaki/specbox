require "csv"

class SpecimensController < ApplicationController
  include ApplicationHelper
  before_action :set_specimen, only: %i[ show edit update destroy ]
  before_action :validate_user, only: %i[ show edit update destroy ]
  before_action :require_login
  before_action :save_and_load_filters
  before_action :save_params_in_session, only: %i[ index ]

  def save_params_in_session
    session[:specimens_index_sort] = "" unless session[:specimens_index_sort]
    session[:specimens_index_direction] = "" unless session[:specimens_index_direction]
    session[:specimens_index_page] = 1 unless session[:specimens_index_page]
    session[:old_ranmemory_specimens_index_html] = {} unless session[:old_ranmemory_specimens_index_html]

    session[:specimens_index_page] = 1 if params[:q].present? && params[:q].empty?.! && params[:q].to_h != session[:old_ranmemory_specimens_index_html]

    session[:specimens_index_sort] = params[:sort] if params[:sort].present?
    session[:specimens_index_direction] = params[:direction] if params[:direction].present?
    session[:specimens_index_page] = params[:page] if params[:page].present?
    session[:old_ranmemory_specimens_index_html] = session[:ranmemory_specimens_index_html]
  end

  # GET /specimens or /specimens.json
  def index
    @search = Specimen.where(user_id: current_user_id).ransack(params[:q])
    @search.sorts = "date_last_modified desc" if @search.sorts.empty?

    if session[:specimens_index_sort].present? && session[:specimens_index_direction].present?
      @search.sorts.clear
      @search.sorts = [ "#{session[:specimens_index_sort]} #{session[:specimens_index_direction]}", "date_last_modified desc" ]
    end

    @specimens = @search.result(distinct: true)

    if params[:q].present? &&
       params[:q][:within_latitude].present? &&
       params[:q][:within_longitude].present? &&
       params[:q][:within_radius].present?

      lat = params[:q][:within_latitude]
      lon = params[:q][:within_longitude]
      radius = params[:q][:within_radius]

      @specimens = @specimens.within_distance_from(lat, lon, radius)
    end

    @specimens = @specimens.page(session[:specimens_index_page] || 1)
  end

  # GET /specimens/1 or /specimens/1.json
  def show
    Specimen.where(user_id: current_user_id).find(params[:id])
    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  # GET /specimens/new
  def new
    @specimen = if params[:base_id].present?
              base_record = Specimen.find(params[:base_id])
              new_record = base_record.dup
              new_record.image1 = nil
              new_record.image2 = nil
              new_record.image3 = nil
              new_record.image4 = nil
              new_record.image5 = nil
              new_record.tours = base_record.tours
              new_record
    else
              Specimen.new
    end
  end

  # GET /specimens/1/edit
  def edit
  end

  # POST /specimens or /specimens.json
  def create
    specimen_params[:user_id] = current_user_id
    specimen_params_with_user = specimen_params
    specimen_params_with_user[:user_id] = current_user_id
    specimen_params_with_user.delete(:bulk_create_num)

    bulk_create_num = specimen_params[:bulk_create_num].to_i

    respond_to do |format|
      begin
        # NOTE: できればバルクインサートしたいが、バルクインサートではコールバックが効かないため、CarrierWaveによる画像保存に支障が出る
        # TODO: CarrierWaveによる画像保存と両立する方法が思いついたらバルクインサート化
        bulk_create_num.times do
          @specimen = Specimen.new(specimen_params_with_user)
          @specimen.save!
        end
        format.html { redirect_to specimens_url_with_ranmemory, notice: t("notice.create") }
        format.json { render :show, status: :created, location: @specimen }
      rescue
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @specimen.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /specimens/1 or /specimens/1.json
  def update
    update_params = specimen_params
    respond_to do |format|
      if @specimen.update(update_params)
        format.html { redirect_to specimens_url_with_ranmemory, notice: t("notice.update") }
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
    # 削除前にリファラーを確認して分岐
    was_on_show = request.referer&.include?("/specimens/#{@specimen.id}")

    respond_to do |format|
      format.html { redirect_to specimens_url_with_ranmemory, notice: t("notice.destroy") }
      format.json { head :no_content }
      format.turbo_stream do
        if was_on_show
          redirect_to specimens_path(q: session[:ranmemory_specimens_index_html]), notice: t("notice.destroy")
        else
          render turbo_stream: turbo_stream.remove(@specimen)
        end
      end
    end
  end

  def bulk_update
    bulk_ids = params[:bulk_ids].blank? ? [] : JSON.parse(params[:bulk_ids])
    bulk_columns = params[:bulk_columns].blank? ? [] : JSON.parse(params[:bulk_columns])

    respond_to do |format|
      if bulk_ids.empty?
        format.html { redirect_to specimens_url_with_ranmemory, alert: "一括更新対象のデータが選択されていません" }
      elsif bulk_columns.empty?
        format.html { redirect_to specimens_url_with_ranmemory, alert: "一括更新対象の項目が選択されていません" }
      else
        bulk_params = {}
        bulk_columns.each do |col|
          bulk_params[col.to_sym] = params[col.to_sym]
        end

        if Specimen.where(id: bulk_ids, user_id: current_user_id).update_all(bulk_params)
          format.html { redirect_to specimens_url_with_ranmemory, notice: "一括更新に成功しました" }
        else
          format.html { redirect_to specimens_url_with_ranmemory, alert: "一括更新に失敗しました" }
        end
      end
    end
  end

  def bulk_delete
    bulk_ids = params[:bulk_ids].blank? ? [] : JSON.parse(params[:bulk_ids])

    respond_to do |format|
      if bulk_ids.empty?
        format.html { redirect_to specimens_url_with_ranmemory, alert: "一括削除対象のデータが選択されていません" }
      else
        if Specimen.where(id: bulk_ids, user_id: current_user_id).destroy_all
          format.html { redirect_to specimens_url_with_ranmemory, notice: "一括削除に成功しました" }
        else
          format.html { redirect_to specimens_url_with_ranmemory, alert: "一括削除に失敗しました" }
        end
      end
    end
  end

  def export_csv
    @specimens = search_results_for_csv
    send_data generate_csv(@specimens),
              filename: "specimens.csv",
              type: "text/csv; charset=UTF-8"
  end

  def export_csv_excel
    @specimens = search_results_for_csv
    bom = "\uFEFF"  # UTF-8 BOM
    send_data bom + generate_csv(@specimens),
              filename: "specimens_excel.csv",
              type: "text/csv; charset=UTF-8"
  end

  def set_session_key_identifier
    "specimens_index_html"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_specimen
      @specimen = Specimen.find_by(id: params[:id], user_id: current_user_id)
    end

    # Only allow a list of trusted parameters through.
    def specimen_params
      params.require(:specimen).permit(
        :note,
        :image1, :image2, :image3, :image4, :image5,
        :remove_image1, :remove_image2, :remove_image3, :remove_image4, :remove_image5,
        :bulk_ids, :bulk_columns, :bulk_create_num,
        :within_latitude, :within_longitude, :within_radius
      )
    end

    def validate_user
      unless @specimen.user_id == current_user_id
        redirect_to specimens_path, notice: "ご指定のIDは存在しません"
      end
    end

    def search_results_for_csv
      search = Specimen.where(user_id: current_user_id).ransack(params[:q])
      search.sorts = "date_last_modified desc" if search.sorts.empty?

      if session[:specimens_index_sort].present? && session[:specimens_index_direction].present?
        search.sorts.clear
        search.sorts = [
          "#{session[:specimens_index_sort]} #{session[:specimens_index_direction]}",
          "date_last_modified desc"
        ]
      end

      result = search.result

      if params[:q].present? &&
         params[:q][:within_latitude].present? &&
         params[:q][:within_longitude].present? &&
         params[:q][:within_radius].present?

        lat = params[:q][:within_latitude]
        lon = params[:q][:within_longitude]
        radius = params[:q][:within_radius]

        result = result.within_distance_from(lat, lon, radius)
      end

      result
    end

    def generate_csv(records)
      headers = %w[
        kingdom phylum class_name order suborder family subfamily tribe subtribe
        genus subgenus species subspecies scientific_name_author name_publishedin_year
        change_genus_brackets unknown_author_brackets unknown_name_publishedin_year_brackets
        actual_dist_year japanese_name
        continent island_group country island state_provice county
        municipality japanese_place_name japanese_place_name_detail
        longitude latitude coordinate_precision
        minimum_elevation maximum_elevation
        minimum_depth maximum_depth
        note date_last_modified image1 image2 image3 image4 image5
      ]

      CSV.generate(headers: true) do |csv|
        csv << headers

        records.find_each do |sp|
          csv << [
            sp.kingdom, sp.phylum, sp.class_name, sp.order, sp.suborder,
            sp.family, sp.subfamily, sp.tribe, sp.subtribe,
            sp.genus, sp.subgenus, sp.species, sp.subspecies,
            sp.scientific_name_author, sp.name_publishedin_year,
            sp.change_genus_brackets, sp.unknown_author_brackets, sp.unknown_name_publishedin_year_brackets,
            sp.actual_dist_year, sp.japanese_name, sp.distribution,
            sp.collect_point.contient,  # ヘッダは誤字を修正して"continent"として出力
            sp.collect_point.island_group,
            sp.collect_point.country,
            sp.collect_point.island,
            sp.collect_point.state_provice,
            sp.collect_point.county,
            sp.collect_point.municipality,
            sp.collect_point.japanese_place_name,
            sp.collect_point.japanese_place_name_detail,
            sp.collect_point.longitude,
            sp.collect_point.latitude,
            sp.collect_point.coordinate_precision,
            sp.collect_point.minimum_elevation,
            sp.collect_point.maximum_elevation,
            sp.collect_point.minimum_depth,
            sp.collect_point.maximum_depth,
            sp.note,
            sp.date_last_modified&.iso8601,
            sp.image1&.url,
            sp.image2&.url,
            sp.image3&.url,
            sp.image4&.url,
            sp.image5&.url
          ]
        end
      end
    end
end
