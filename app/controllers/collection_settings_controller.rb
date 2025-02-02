class CollectionSettingsController < ApplicationController
  include ApplicationHelper
  before_action :set_collection_setting, only: %i[ show edit update destroy ]
  before_action :validate_user, only: %i[ show edit update destroy ]
  before_action :require_login
  before_action :save_and_load_filters
  before_action :save_params_in_session, only: %i[ index ]

  def save_params_in_session
    session[:collection_settings_index_sort] = "" unless session[:collection_settings_index_sort]
    session[:collection_settings_index_direction] = "" unless session[:collection_settings_index_direction]
    session[:collection_settings_index_page] = 1 unless session[:collection_settings_index_page]
    session[:old_ranmemory_collection_settings_index_html] = {} unless session[:old_ranmemory_collection_settings_index_html]

    session[:collection_settings_index_page] = 1 if params[:q].present? && params[:q].empty?.! && params[:q].to_h != session[:old_ranmemory_collection_settings_index_html]

    session[:collection_settings_index_sort] = params[:sort] if params[:sort].present?
    session[:collection_settings_index_direction] = params[:direction] if params[:direction].present?
    session[:collection_settings_index_page] = params[:page] if params[:page].present?
    session[:old_ranmemory_collection_settings_index_html] = session[:ranmemory_collection_settings_index_html]
  end

  # GET /collection_settings or /collection_settings.json
  def index
    @search = CollectionSetting.where(user_id: current_user_id).ransack(params[:q])
    @search.sorts = "created_at desc" if @search.sorts.empty?

    if session[:collection_settings_index_sort].present? && session[:collection_settings_index_direction].present?
      @search.sorts.clear
      @search.sorts = [ "#{session[:collection_settings_index_sort]} #{session[:collection_settings_index_direction]}", "created_at desc" ]
    end

    @collection_settings = @search.result.page(session[:collection_settings_index_page])
  end

  # GET /collection_settings/1 or /collection_settings/1.json
  def show
    CollectionSetting.where(user_id: current_user_id).find(params[:id])
    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  # GET /collection_settings/new
  def new
    @collection_setting = if params[:base_id].present?
                            CollectionSetting.find(params[:base_id]).dup
    else
                            CollectionSetting.new
    end
  end

  # GET /collection_settings/1/edit
  def edit
  end

  # POST /collection_settings or /collection_settings.json
  def create
    collection_setting_params[:user_id] = current_user_id
    collection_setting_params_with_user = collection_setting_params
    collection_setting_params_with_user[:user_id] = current_user_id
    collection_setting_params_with_user.delete(:bulk_create_num)

    bulk_create_num = collection_setting_params[:bulk_create_num].to_i

    respond_to do |format|
      begin
        # NOTE: できればバルクインサートしたいが、バルクインサートではコールバックが効かないため、CarrierWaveによる画像保存に支障が出る
        # TODO: CarrierWaveによる画像保存と両立する方法が思いついたらバルクインサート化
        bulk_create_num.times do
          @collection_setting = CollectionSetting.new(collection_setting_params_with_user)
          @collection_setting.save!
        end
        format.html { redirect_to collection_settings_url_with_ranmemory, notice: t("notice.create") }
        format.json { render :show, status: :created, location: @collection_setting }
      rescue
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @collection_setting.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /collection_settings/1 or /collection_settings/1.json
  def update
    respond_to do |format|
      if @collection_setting.update(collection_setting_params)
        format.html { redirect_to collection_settings_url_with_ranmemory, notice: t("notice.update") }
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
    # 削除前にリファラーを確認して分岐
    was_on_show = request.referer&.include?("/collection_settings/#{@collection_setting.id}")

    respond_to do |format|
      format.html { redirect_to collection_settings_url_with_ranmemory, notice: t("notice.destroy") }
      format.json { head :no_content }
      format.turbo_stream do
        if was_on_show
          redirect_to collection_settings_path(q: session[:ranmemory_collection_settings_index_html]), notice: t("notice.destroy")
        else
          render turbo_stream: turbo_stream.remove(@collection_setting)
        end
      end
    end
  end

  def bulk_update
    bulk_ids = params[:bulk_ids].blank? ? [] : JSON.parse(params[:bulk_ids])
    bulk_columns = params[:bulk_columns].blank? ? [] : JSON.parse(params[:bulk_columns])

    respond_to do |format|
      if bulk_ids.empty?
        format.html { redirect_to collection_settings_url_with_ranmemory, alert: "一括更新対象のデータが選択されていません" }
      elsif bulk_columns.empty?
        format.html { redirect_to collection_settings_url_with_ranmemory, alert: "一括更新対象の項目が選択されていません" }
      else
        bulk_params = {}
        bulk_columns.each do |col|
          bulk_params[col.to_sym] = params[col.to_sym]
        end

        if CollectionSetting.where(id: bulk_ids, user_id: current_user_id).update_all(bulk_params)
          format.html { redirect_to collection_settings_url_with_ranmemory, notice: "一括更新に成功しました" }
        else
          format.html { redirect_to collection_settings_url_with_ranmemory, alert: "一括更新に失敗しました" }
        end
      end
    end
  end

  def bulk_delete
    bulk_ids = params[:bulk_ids].blank? ? [] : JSON.parse(params[:bulk_ids])

    respond_to do |format|
      if bulk_ids.empty?
        format.html { redirect_to collection_settings_url_with_ranmemory, alert: "一括削除対象のデータが選択されていません" }
      else
        if CollectionSetting.where(id: bulk_ids, user_id: current_user_id).delete_all
          format.html { redirect_to collection_settings_url_with_ranmemory, notice: "一括削除に成功しました" }
        else
          format.html { redirect_to collection_settings_url_with_ranmemory, alert: "一括削除に失敗しました" }
        end
      end
    end
  end

  def set_session_key_identifier
    "collection_settings_index_html"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_collection_setting
      @collection_setting = CollectionSetting.find_by(id: params[:id], user_id: current_user_id)
    end

    # Only allow a list of trusted parameters through.
    def collection_setting_params
      params.require(:collection_setting).permit(:collection_name, :institution_code, :latest_collection_code, :note, :bulk_ids, :bulk_columns, :bulk_create_num)
    end

    def validate_user
      unless @collection_setting.user_id == current_user_id
        redirect_to collection_settings_path, notice: "ご指定のIDは存在しません"
      end
    end
end
