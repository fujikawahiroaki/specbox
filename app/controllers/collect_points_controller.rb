class CollectPointsController < ApplicationController
  include ApplicationHelper
  before_action :set_collect_point, only: %i[ show edit update destroy ]
  before_action :validate_user, only: %i[ show edit update destroy ]
  before_action :require_login
  before_action :save_and_load_filters
  before_action :save_params_in_session, only: %i[ index ]

  def save_params_in_session
    session[:collect_points_index_sort] = "" unless session[:collect_points_index_sort]
    session[:collect_points_index_direction] = "" unless session[:collect_points_index_direction]
    session[:collect_points_index_page] = 1 unless session[:collect_points_index_page]
    session[:old_ranmemory_collect_points_index_html] = {} unless session[:old_ranmemory_collect_points_index_html]

    session[:collect_points_index_page] = 1 if params[:q].present? && params[:q].empty?.! && params[:q].to_h != session[:old_ranmemory_collect_points_index_html]

    session[:collect_points_index_sort] = params[:sort] if params[:sort].present?
    session[:collect_points_index_direction] = params[:direction] if params[:direction].present?
    session[:collect_points_index_page] = params[:page] if params[:page].present?
    session[:old_ranmemory_collect_points_index_html] = session[:ranmemory_collect_points_index_html]
  end

  # GET /collect_points or /collect_points.json
  def index
    @search = CollectPoint.where(user_id: current_user_id).ransack(params[:q])
    @search.sorts = "created_at desc" if @search.sorts.empty?

    if session[:collect_points_index_sort].present? && session[:collect_points_index_direction].present?
      @search.sorts.clear
      @search.sorts = [ "#{session[:collect_points_index_sort]} #{session[:collect_points_index_direction]}", "created_at desc" ]
    end

    @collect_points = @search.result

    if params[:q].present? &&
       params[:q][:within_latitude].present? &&
       params[:q][:within_longitude].present? &&
       params[:q][:within_radius].present?

      lat = params[:q][:within_latitude]
      lon = params[:q][:within_longitude]
      radius = params[:q][:within_radius]

      @collect_points = @collect_points.within_distance_from(lat, lon, radius)
    end

    @collect_points = @collect_points.page(session[:collect_points_index_page] || 1)
  end

  # GET /collect_points/1 or /collect_points/1.json
  def show
    CollectPoint.where(user_id: current_user_id).find(params[:id])
    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  # GET /collect_points/new
  def new
    @collect_point = if params[:base_id].present?
              base_record = CollectPoint.find(params[:base_id])
              new_record = base_record.dup
              new_record.image1 = nil
              new_record.image2 = nil
              new_record.image3 = nil
              new_record.image4 = nil
              new_record.image5 = nil
              new_record.tours = base_record.tours
              new_record
    else
              CollectPoint.new
    end
    @copied_tours = @collect_point.tours
    @tours = Tour.where(user_id: current_user_id).order(start_date: :desc)
  end

  # GET /collect_points/1/edit
  def edit
    @tours = Tour.where(user_id: current_user_id).order(start_date: :desc)
  end

  # POST /collect_points or /collect_points.json
  def create
    collect_point_params[:user_id] = current_user_id
    collect_point_params_with_user = collect_point_params
    collect_point_params_with_user[:user_id] = current_user_id
    collect_point_params_with_user.delete(:bulk_create_num)
    collect_point_params_with_user.delete(:longitude)
    collect_point_params_with_user.delete(:latitude)
    collect_point_params_with_user.delete(:tour_ids)

    location_factory = RGeo::Geographic.spherical_factory(srid: 4326)
    location = location_factory.point(
      collect_point_params[:longitude].to_f,
      collect_point_params[:latitude].to_f
    )

    tour_ids = collect_point_params[:tour_ids]

    bulk_create_num = collect_point_params[:bulk_create_num].to_i

    respond_to do |format|
      begin
        # NOTE: できればバルクインサートしたいが、バルクインサートではコールバックが効かないため、CarrierWaveによる画像保存に支障が出る
        # TODO: CarrierWaveによる画像保存と両立する方法が思いついたらバルクインサート化
        bulk_create_num.times do
          @collect_point = CollectPoint.new(collect_point_params_with_user)
          @collect_point.location = location
          @collect_point.save!
          @collect_point.tour_ids = tour_ids
        end
        format.html { redirect_to collect_points_url_with_ranmemory, notice: t("notice.create") }
        format.json { render :show, status: :created, location: @collect_point }
      rescue
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @collect_point.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /collect_points/1 or /collect_points/1.json
  def update
    location_factory = RGeo::Geographic.spherical_factory(srid: 4326)
    location = location_factory.point(
      collect_point_params[:longitude].to_f,
      collect_point_params[:latitude].to_f
    )
    update_params = collect_point_params
    update_params.delete(:longitude)
    update_params.delete(:latitude)
    @collect_point.location = location
    respond_to do |format|
      if @collect_point.update(update_params)
        format.html { redirect_to collect_points_url_with_ranmemory, notice: t("notice.update") }
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
    # 削除前にリファラーを確認して分岐
    was_on_show = request.referer&.include?("/collect_points/#{@collect_point.id}")

    respond_to do |format|
      format.html { redirect_to collect_points_url_with_ranmemory, notice: t("notice.destroy") }
      format.json { head :no_content }
      format.turbo_stream do
        if was_on_show
          redirect_to collect_points_path(q: session[:ranmemory_collect_points_index_html]), notice: t("notice.destroy")
        else
          render turbo_stream: turbo_stream.remove(@collect_point)
        end
      end
    end
  end

  def bulk_update
    bulk_ids = params[:bulk_ids].blank? ? [] : JSON.parse(params[:bulk_ids])
    bulk_columns = params[:bulk_columns].blank? ? [] : JSON.parse(params[:bulk_columns])

    respond_to do |format|
      if bulk_ids.empty?
        format.html { redirect_to collect_points_url_with_ranmemory, alert: "一括更新対象のデータが選択されていません" }
      elsif bulk_columns.empty?
        format.html { redirect_to collect_points_url_with_ranmemory, alert: "一括更新対象の項目が選択されていません" }
      else
        bulk_params = {}
        bulk_columns.each do |col|
          bulk_params[col.to_sym] = params[col.to_sym]
        end

        if CollectPoint.where(id: bulk_ids, user_id: current_user_id).update_all(bulk_params)
          format.html { redirect_to collect_points_url_with_ranmemory, notice: "一括更新に成功しました" }
        else
          format.html { redirect_to collect_points_url_with_ranmemory, alert: "一括更新に失敗しました" }
        end
      end
    end
  end

  def bulk_delete
    bulk_ids = params[:bulk_ids].blank? ? [] : JSON.parse(params[:bulk_ids])

    respond_to do |format|
      if bulk_ids.empty?
        format.html { redirect_to collect_points_url_with_ranmemory, alert: "一括削除対象のデータが選択されていません" }
      else
        if CollectPoint.where(id: bulk_ids, user_id: current_user_id).delete_all
          format.html { redirect_to collect_points_url_with_ranmemory, notice: "一括削除に成功しました" }
        else
          format.html { redirect_to collect_points_url_with_ranmemory, alert: "一括削除に失敗しました" }
        end
      end
    end
  end

  def reverse_zipcode
    address = params[:for_reverce_zipcode]
    api_key = ENV["ZIPCODE_REVERCE_API_KEY"]
    uri = URI("https://zipcode.milkyfieldcompany.com/api/v1/findzipcode")
    uri.query = URI.encode_www_form({ apikey: api_key, address: address })

    begin
      response = Net::HTTP.get_response(uri)

      Rails.logger.debug("Zipcode API status: #{response.code}")
      Rails.logger.debug("Zipcode API body: #{response.body}")

      if response.is_a?(Net::HTTPSuccess)
        json = JSON.parse(response.body)
        Rails.logger.debug(json)
        render json: { data: json }
      else
        render json: { error: "Zipcode API returned status #{response.code}" }, status: response.code.to_i
      end
    rescue => e
      Rails.logger.error("reverse_zipcode API error: #{e.message}")
      render json: { error: "取得失敗: #{e.message}" }, status: 500
    end
  end

  def set_session_key_identifier
    "collect_points_index_html"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_collect_point
      @collect_point = CollectPoint.find_by(id: params[:id], user_id: current_user_id)
    end

    # Only allow a list of trusted parameters through.
    def collect_point_params
      params.require(:collect_point).permit(:contient, :island_group, :island, :country, :state_provice, :county, :municipality, :verbatim_locality, :japanese_place_name, :japanese_place_name_detail, :coordinate_precision, :latitude, :longitude, :minimum_elevation, :maximum_elevation, :minimum_depth, :maximum_depth, :note, :image1, :image2, :image3, :image4, :image5, :remove_image1, :remove_image2, :remove_image3, :remove_image4, :remove_image5, :bulk_ids, :bulk_columns, :bulk_create_num, :for_reverce_zipcode, :latitude_eq, :latitude_gteq, :latitude_lteq, :longitude_eq, :longitude_gteq, :longitude_lteq, :within_latitude, :within_longitude, :within_radius, tour_ids: [])
    end

    def validate_user
      unless @collect_point.user_id == current_user_id
        redirect_to collect_points_path, notice: "ご指定のIDは存在しません"
      end
    end
end
