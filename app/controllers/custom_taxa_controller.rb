require "csv"

class CustomTaxaController < ApplicationController
  include ApplicationHelper
  before_action :set_custom_taxon, only: %i[ show edit update destroy ]
  before_action :validate_user, only: %i[ show edit update destroy ]
  before_action :require_login
  before_action :save_and_load_filters
  before_action :save_params_in_session, only: %i[ index ]

  def save_params_in_session
    session[:custom_taxa_index_sort] = "" unless session[:custom_taxa_index_sort]
    session[:custom_taxa_index_direction] = "" unless session[:custom_taxa_index_direction]
    session[:custom_taxa_index_page] = 1 unless session[:custom_taxa_index_page]
    session[:old_ranmemory_custom_taxa_index_html] = {} unless session[:old_ranmemory_custom_taxa_index_html]

    session[:custom_taxa_index_page] = 1 if params[:q].present? && params[:q].empty?.! && params[:q].to_h != session[:old_ranmemory_custom_taxa_index_html]

    session[:custom_taxa_index_sort] = params[:sort] if params[:sort].present?
    session[:custom_taxa_index_direction] = params[:direction] if params[:direction].present?
    session[:custom_taxa_index_page] = params[:page] if params[:page].present?
    session[:old_ranmemory_custom_taxa_index_html] = session[:ranmemory_custom_taxa_index_html]
  end

  # GET /custom_taxa or /custom_taxa.json
  def index
    @search = CustomTaxon.includes(:all_taxon).references(:all_taxon).where(user_id: current_user_id).ransack(params[:q])
    @search.sorts = "created_at desc" if @search.sorts.empty?

    if session[:custom_taxa_index_sort].present? && session[:custom_taxa_index_direction].present?
      @search.sorts.clear
      @search.sorts = [ "#{session[:custom_taxa_index_sort]} #{session[:custom_taxa_index_direction]}", "created_at desc" ]
    end

    @custom_taxa = @search.result
    @custom_taxa = @custom_taxa.page(session[:custom_taxa_index_page] || 1)
  end

  # GET /custom_taxa/1 or /custom_taxa/1.json
  def show
    CustomTaxon.where(user_id: current_user_id).find(params[:id])
    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  # GET /custom_taxa/new
  def new
    @custom_taxon = if params[:base_id].present?
              base_record = CustomTaxon.includes(:all_taxon).find(params[:base_id])
              new_record = base_record.dup
              new_record.image1 = nil
              new_record.image2 = nil
              new_record.image3 = nil
              new_record.image4 = nil
              new_record.image5 = nil
              new_record
    else
              CustomTaxon.new
    end
    @custom_taxon.build_all_taxon unless @custom_taxon.all_taxon
    @custom_taxon
  end

  # GET /custom_taxa/1/edit
  def edit
  end

  # POST /custom_taxa or /custom_taxa.json
  def create
    # Strong Params 取得
    base_params = custom_taxon_params.dup
    bulk_create_num = base_params.delete(:bulk_create_num).to_i
    base_params[:user_id] = current_user_id
    # bulk_create_num は all_taxon_attributes に不要なので remove
    base_params.delete(:bulk_create_num)

    respond_to do |format|
      begin
        last = nil
        bulk_create_num.times do
          last = CustomTaxon.new(base_params)
          # ループ中も必ず build_all_taxon しておく
          last.build_all_taxon if last.all_taxon.nil?
          last.save!
        end
        format.html { redirect_to custom_taxa_url_with_ranmemory, notice: t("notice.create") }
        format.json { render :show, status: :created, location: last }
      rescue ActiveRecord::RecordInvalid
        # 保存に失敗したら new ビューへ。new で build_all_taxon しているので all_taxon も存在
        @custom_taxon = last || CustomTaxon.new(base_params)
        @custom_taxon.build_all_taxon if @custom_taxon.all_taxon.nil?
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @custom_taxon.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /custom_taxa/1 or /custom_taxa/1.json
  def update
    update_params = custom_taxon_params.dup
    respond_to do |format|
      if @custom_taxon.update(update_params)
        format.html { redirect_to custom_taxa_url_with_ranmemory, notice: t("notice.update") }
        format.json { render :show, status: :ok, location: @custom_taxon }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @custom_taxon.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /custom_taxa/1 or /custom_taxa/1.json
  def destroy
    @custom_taxon.destroy!
    # 削除前にリファラーを確認して分岐
    was_on_show = request.referer&.include?("/custom_taxa/#{@custom_taxon.id}")

    respond_to do |format|
      format.html { redirect_to custom_taxa_url_with_ranmemory, notice: t("notice.destroy") }
      format.json { head :no_content }
      format.turbo_stream do
        if was_on_show
          redirect_to custom_taxa_path(q: session[:ranmemory_custom_taxa_index_html]), notice: t("notice.destroy")
        else
          render turbo_stream: turbo_stream.remove(@custom_taxon)
        end
      end
    end
  end

  def bulk_update
    bulk_ids = params[:bulk_ids].blank? ? [] : JSON.parse(params[:bulk_ids])
    bulk_columns = params[:bulk_columns].blank? ? [] : JSON.parse(params[:bulk_columns])

    respond_to do |format|
      if bulk_ids.empty?
        format.html { redirect_to custom_taxa_url_with_ranmemory, alert: "一括更新対象のデータが選択されていません" }
      elsif bulk_columns.empty?
        format.html { redirect_to custom_taxa_url_with_ranmemory, alert: "一括更新対象の項目が選択されていません" }
      else
        bulk_params = {}
        bulk_columns.each do |col|
          bulk_params[col.to_sym] = params[col.to_sym]
        end

        if AllTaxon.joins(:custom_taxon).where(custom_taxa: { user_id: current_user_id, taxon_ptr_id: bulk_ids }).update_all(bulk_params)
          format.html { redirect_to custom_taxa_url_with_ranmemory, notice: "一括更新に成功しました" }
        else
          format.html { redirect_to custom_taxa_url_with_ranmemory, alert: "一括更新に失敗しました" }
        end
      end
    end
  end

  def bulk_delete
    bulk_ids = params[:bulk_ids].blank? ? [] : JSON.parse(params[:bulk_ids])

    respond_to do |format|
      if bulk_ids.empty?
        format.html { redirect_to custom_taxa_url_with_ranmemory, alert: "一括削除対象のデータが選択されていません" }
      else
        if AllTaxon.joins(:custom_taxon).where(custom_taxa: { user_id: current_user_id, taxon_ptr_id: bulk_ids }).destroy_all
          format.html { redirect_to custom_taxa_url_with_ranmemory, notice: "一括削除に成功しました" }
        else
          format.html { redirect_to custom_taxa_url_with_ranmemory, alert: "一括削除に失敗しました" }
        end
      end
    end
  end

  def export_csv
    @custom_taxa = search_results_for_csv
    send_data generate_csv(@custom_taxa),
              filename: "custom_taxa.csv",
              type: "text/csv; charset=UTF-8"
  end

  def export_csv_excel
    @custom_taxa = search_results_for_csv
    bom = "\uFEFF"  # UTF-8 BOM
    send_data bom + generate_csv(@custom_taxa),
              filename: "custom_taxa_excel.csv",
              type: "text/csv; charset=UTF-8"
  end

  def set_session_key_identifier
    "custom_taxa_index_html"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_custom_taxon
      @custom_taxon = CustomTaxon.find_by(taxon_ptr_id: params[:id], user_id: current_user_id)
    end

    # Only allow a list of trusted parameters through.
    def custom_taxon_params
      params.require(:custom_taxon).permit(
        :bulk_ids, :bulk_columns, :bulk_create_num,
        all_taxon_attributes: [
          :id,
          :kingdom, :phylum, :class_name, :order, :suborder, :family,
          :subfamily, :tribe, :subtribe, :genus, :subgenus, :species, :subspecies,
          :scientific_name_author, :name_publishedin_year, :change_genus_brackets,
          :unknown_author_brackets, :unknown_name_publishedin_year_brackets,
          :actual_dist_year, :japanese_name, :distribution, :note,
          :image1, :image2, :image3, :image4, :image5,
          :remove_image1, :remove_image2, :remove_image3, :remove_image4, :remove_image5
        ]
      )
    end

    def validate_user
      unless @custom_taxon.user_id == current_user_id
        redirect_to custom_taxa_path, notice: "ご指定のIDは存在しません"
      end
    end

    def search_results_for_csv
      @search = CustomTaxon.includes(:all_taxon).references(:all_taxon).where(user_id: current_user_id).ransack(params[:q])
      @search.sorts = "created_at desc" if @search.sorts.empty?

      if session[:custom_taxa_index_sort].present? && session[:custom_taxa_index_direction].present?
        @search.sorts.clear
        @search.sorts = [
          "#{session[:custom_taxa_index_sort]} #{session[:custom_taxa_index_direction]}",
          "created_at desc"
        ]
      end

      @search.result
    end

    def generate_csv(records)
      headers = %w[
          kingdom phylum class_name order suborder family subfamily tribe subtribe
          genus subgenus species subspecies scientific_name_author name_publishedin_year
          change_genus_brackets unknown_author_brackets unknown_name_publishedin_year_brackets
          actual_dist_year japanese_name distribution note created_at
          image1 image2 image3 image4 image5
        ]

      CSV.generate(headers: true) do |csv|
        csv << headers
        records.find_each do |taxon|
          csv << [
            taxon.kingdom, taxon.phylum, taxon.class_name, taxon.order, taxon.suborder,
            taxon.family, taxon.subfamily, taxon.tribe, taxon.subtribe,
            taxon.genus, taxon.subgenus, taxon.species, taxon.subspecies,
            taxon.scientific_name_author, taxon.name_publishedin_year,
            taxon.change_genus_brackets, taxon.unknown_author_brackets, taxon.unknown_name_publishedin_year_brackets,
            taxon.actual_dist_year, taxon.japanese_name, taxon.distribution, taxon.note,
            taxon.created_at&.iso8601,
            taxon.image1&.url, taxon.image2&.url, taxon.image3&.url, taxon.image4&.url, taxon.image5&.url
          ]
        end
      end
    end
end
