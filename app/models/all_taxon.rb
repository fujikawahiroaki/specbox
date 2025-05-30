class AllTaxon < ApplicationRecord
  include ImagePath

  self.table_name = "all_taxa"
  self.primary_key = "id"

  has_one :custom_taxon, foreign_key: "taxon_ptr_id", dependent: :destroy
  has_one :default_taxon, foreign_key: "taxon_ptr_id", dependent: :destroy

  attribute :id, :uuid, default: -> { SecureRandom.uuid }

  # 画像アップロード（CarrierWave）
  mount_uploader :image1, DjangoPictureUploader
  mount_uploader :image2, DjangoPictureUploader
  mount_uploader :image3, DjangoPictureUploader
  mount_uploader :image4, DjangoPictureUploader
  mount_uploader :image5, DjangoPictureUploader

  # 基本バリデーション（Unidentified, spなどはデフォルトで埋まる）
  validates :kingdom,                 length: { minimum: 0, maximum: 30 }, exclusion: { in: [ nil ] }
  validates :phylum,                  length: { minimum: 0, maximum: 30 }, exclusion: { in: [ nil ] }
  validates :class_name,              length: { minimum: 0, maximum: 30 }, exclusion: { in: [ nil ] }
  validates :order,                   length: { minimum: 0, maximum: 30 }, exclusion: { in: [ nil ] }
  validates :suborder,                length: { minimum: 0, maximum: 30 }, exclusion: { in: [ nil ] }
  validates :family,                  length: { minimum: 0, maximum: 30 }, exclusion: { in: [ nil ] }
  validates :subfamily,               length: { minimum: 0, maximum: 30 }, exclusion: { in: [ nil ] }
  validates :tribe,                   length: { minimum: 0, maximum: 30 }, exclusion: { in: [ nil ] }
  validates :subtribe,                length: { minimum: 0, maximum: 30 }, exclusion: { in: [ nil ] }
  validates :genus,                   length: { minimum: 0, maximum: 30 }, exclusion: { in: [ nil ] }
  validates :subgenus,                length: { minimum: 0, maximum: 30 }, exclusion: { in: [ nil ] }
  validates :species,                 length: { minimum: 0, maximum: 30 }, exclusion: { in: [ nil ] }
  validates :subspecies,              length: { minimum: 0, maximum: 30 }, exclusion: { in: [ nil ] }
  validates :scientific_name_author,  length: { minimum: 0, maximum: 50 }, exclusion: { in: [ nil ] }
  validates :name_publishedin_year,   numericality: { only_integer: true, greater_than_or_equal_to: 0 }, exclusion: { in: [ nil ] }
  validates :actual_dist_year,        numericality: { only_integer: true, greater_than_or_equal_to: 0 }, exclusion: { in: [ nil ] }

  validates :change_genus_brackets,                inclusion: { in: [ true, false ] }
  validates :unknown_author_brackets,              inclusion: { in: [ true, false ] }
  validates :unknown_name_publishedin_year_brackets, inclusion: { in: [ true, false ] }

  validates :japanese_name, length: { minimum: 0, maximum: 30 }, exclusion: { in: [ nil ] }
  validates :distribution, length: { minimum: 0, maximum: 500 }, exclusion: { in: [ nil ] }
  validates :note,         length: { minimum: 0, maximum: 500 }, exclusion: { in: [ nil ] }

  def scientific_name
    [ genus, species, subspecies ].reject(&:blank?).join(" ")
  end

  def scientific_and_japanese_name
    [ genus, species, subspecies, japanese_name ].reject(&:blank?).join(" ")
  end

  def to_s
    genus.blank? ? "Unidentified" : [ genus, species, subspecies ].join
  end

  def all_taxon_name
    [
      kingdom, phylum, class_name, order, suborder,
      family, subfamily, tribe, subtribe,
      genus, subgenus, species, subspecies,
      japanese_name
    ].reject(&:blank?).join(" ")
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[
      id created_at
      kingdom phylum class_name order suborder family subfamily tribe subtribe
      genus subgenus species subspecies
      scientific_name_author name_publishedin_year
      change_genus_brackets unknown_author_brackets unknown_name_publishedin_year_brackets
      actual_dist_year japanese_name distribution note
      image1 image2 image3 image4 image5
      scientific_name scientific_and_japanese_name created_at_date all_taxon_name
    ]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end

  ransacker :created_at_date do
    Arel.sql("DATE(created_at)")
  end

  ransacker :scientific_name do
    Arel.sql("concat_ws(' ', genus, species, subspecies)")
  end

  ransacker :scientific_and_japanese_name do
    Arel.sql("concat_ws(' ', genus, species, subspecies, japanese_name)")
  end

  ransacker :all_taxon_name do |parent|
    Arel::Nodes::NamedFunction.new(
      "concat_ws",
      [
        Arel::Nodes.build_quoted(" "),
        parent.table[:kingdom],
        parent.table[:phylum],
        parent.table[:class_name],
        parent.table[:order],
        parent.table[:suborder],
        parent.table[:family],
        parent.table[:subfamily],
        parent.table[:tribe],
        parent.table[:subtribe],
        parent.table[:genus],
        parent.table[:subgenus],
        parent.table[:species],
        parent.table[:subspecies],
        parent.table[:japanese_name]
      ]
    )
  end
end
