class CustomTaxon < ApplicationRecord
  self.table_name = "custom_taxa"
  self.primary_key = "taxon_ptr_id"

  belongs_to :all_taxon, foreign_key: "taxon_ptr_id", inverse_of: :custom_taxon

  accepts_nested_attributes_for :all_taxon, update_only: true

  after_initialize :ensure_all_taxon

  def ensure_all_taxon
    build_all_taxon if all_taxon.nil?
  end

  def initialize_dup(other)
    super
    if other.all_taxon
      # sourceのAllTaxonをdupして関連にセット
      new_taxon = other.all_taxon.dup
      # IDが残っていると紐付けられないのでクリア
      new_taxon.id = nil
      self.all_taxon = new_taxon
    end
  end

  def to_param
    taxon_ptr_id
  end

  delegate :created_at,
           :kingdom, :phylum, :class_name, :order, :suborder,
           :family, :subfamily, :tribe, :subtribe,
           :genus, :subgenus, :species, :subspecies,
           :scientific_name_author, :name_publishedin_year,
           :change_genus_brackets, :unknown_author_brackets, :unknown_name_publishedin_year_brackets,
           :actual_dist_year, :japanese_name, :distribution, :note,
           :image1, :image2, :image3, :image4, :image5,
           :kingdom=, :phylum=, :class_name=, :order=, :suborder=,
           :family=, :subfamily=, :tribe=, :subtribe=,
           :genus=, :subgenus=, :species=, :subspecies=,
           :scientific_name_author=, :name_publishedin_year=,
           :change_genus_brackets=, :unknown_author_brackets=, :unknown_name_publishedin_year_brackets=,
           :actual_dist_year=, :japanese_name=, :distribution=, :note=,
           :image1=, :image2=, :image3=, :image4=, :image5=,
           :scientific_name, :scientific_and_japanese_name, :all_taxon_name, :to_s,
           to: :all_taxon

  attribute :is_private, :boolean, default: -> { true }

  ransack_alias :kingdom,                                :all_taxon_kingdom
  ransack_alias :phylum,                                 :all_taxon_phylum
  ransack_alias :class_name,                             :all_taxon_class_name
  ransack_alias :order,                                  :all_taxon_order
  ransack_alias :suborder,                               :all_taxon_suborder
  ransack_alias :family,                                 :all_taxon_family
  ransack_alias :subfamily,                              :all_taxon_subfamily
  ransack_alias :tribe,                                  :all_taxon_tribe
  ransack_alias :subtribe,                               :all_taxon_subtribe
  ransack_alias :genus,                                  :all_taxon_genus
  ransack_alias :subgenus,                               :all_taxon_subgenus
  ransack_alias :species,                                :all_taxon_species
  ransack_alias :subspecies,                             :all_taxon_subspecies
  ransack_alias :scientific_name_author,                 :all_taxon_scientific_name_author
  ransack_alias :name_publishedin_year,                  :all_taxon_name_publishedin_year
  ransack_alias :change_genus_brackets,                  :all_taxon_change_genus_brackets
  ransack_alias :unknown_author_brackets,                :all_taxon_unknown_author_brackets
  ransack_alias :unknown_name_publishedin_year_brackets, :all_taxon_unknown_name_publishedin_year_brackets
  ransack_alias :actual_dist_year,                       :all_taxon_actual_dist_year
  ransack_alias :japanese_name,                          :all_taxon_japanese_name
  ransack_alias :distribution,                           :all_taxon_distribution
  ransack_alias :note,                                   :all_taxon_note
  ransack_alias :scientific_name,                        :all_taxon_scientific_name
  ransack_alias :created_at_date,                        :all_taxon_created_at_date
  ransack_alias :all_taxon_name,                         :all_taxon_all_taxon_name
  ransack_alias :created_at,                             :all_taxon_created_at
  ransack_alias :scientific_name,                        :all_taxon_scientific_name
  ransack_alias :scientific_and_japanese_name,           :all_taxon_scientific_and_japanese_name

  def self.ransackable_attributes(auth_object = nil)
    AllTaxon.ransackable_attributes(auth_object)
  end

  def self.ransackable_associations(auth_object = nil)
    %w[all_taxon]
  end
end
