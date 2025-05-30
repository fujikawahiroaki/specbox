require "csv"

class DefaultTaxaController < ApplicationController
  include ApplicationHelper
  before_action :require_login
  before_action :save_and_load_filters
  before_action :save_params_in_session, only: %i[index]

  def save_params_in_session
    session[:default_taxa_index_sort] ||= ""
    session[:default_taxa_index_direction] ||= ""
    session[:default_taxa_index_page] ||= 1
    session[:old_ranmemory_default_taxa_index_html] ||= {}

    session[:default_taxa_index_page] = 1 if params[:q].present? && params[:q].to_h != session[:old_ranmemory_default_taxa_index_html]

    session[:default_taxa_index_sort] = params[:sort] if params[:sort].present?
    session[:default_taxa_index_direction] = params[:direction] if params[:direction].present?
    session[:default_taxa_index_page] = params[:page] if params[:page].present?
    session[:old_ranmemory_default_taxa_index_html] = session[:ranmemory_default_taxa_index_html]
  end

  def index
    @search = DefaultTaxon.ransack(params[:q])
    @search.sorts = "created_at desc" if @search.sorts.empty?

    if session[:default_taxa_index_sort].present? && session[:default_taxa_index_direction].present?
      @search.sorts.clear
      @search.sorts = [
        "#{session[:default_taxa_index_sort]} #{session[:default_taxa_index_direction]}",
        "created_at desc"
      ]
    end

    @default_taxa = @search.result
    @default_taxa = @default_taxa.page(session[:default_taxa_index_page] || 1)
  end

  def show
    @default_taxon = DefaultTaxon.find(params[:id])
    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  def export_csv
    @default_taxa = search_results_for_csv
    send_data generate_csv(@default_taxa),
              filename: "default_taxa.csv",
              type: "text/csv; charset=UTF-8"
  end

  def export_csv_excel
    @default_taxa = search_results_for_csv
    bom = "\uFEFF"  # UTF-8 BOM
    send_data bom + generate_csv(@default_taxa),
              filename: "default_taxa_excel.csv",
              type: "text/csv; charset=UTF-8"
  end

  def set_session_key_identifier
    "default_taxa_index_html"
  end

  private

    def search_results_for_csv
      search = DefaultTaxon.ransack(params[:q])
      search.sorts = "created_at desc" if search.sorts.empty?

      if session[:default_taxa_index_sort].present? && session[:default_taxa_index_direction].present?
        search.sorts.clear
        search.sorts = [
          "#{session[:default_taxa_index_sort]} #{session[:default_taxa_index_direction]}",
          "created_at desc"
        ]
      end

      search.result
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
