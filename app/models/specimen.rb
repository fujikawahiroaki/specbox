class Specimen < ApplicationRecord
  include ImagePath

  # 保存のたびに date_last_modified を現在の JST で更新する
  before_save :touch_date_last_modified

  belongs_to :auth_user, foreign_key: :user_id

  # カスタム分類情報
  belongs_to :custom_taxon_info,
             class_name: "CustomTaxon",
             foreign_key: "custom_taxon_info_id",
             optional: true

  # デフォルト分類情報
  belongs_to :default_taxon_info,
             class_name: "DefaultTaxon",
             foreign_key: "default_taxon_info_id",
             optional: true

  # 採集地点情報
  belongs_to :collect_point_info,
             class_name: "CollectPoint",
             foreign_key: "collect_point_info_id",
             optional: true

  # コレクション設定情報
  belongs_to :collection_settings_info,
             class_name: "CollectionSetting",
             foreign_key: "collection_settings_info_id",
             optional: true

  # 採集行情報
  belongs_to :tour,
             class_name: "Tour",
             foreign_key: "tour_id",
             optional: true

  mount_uploader :image1, DjangoPictureUploader
  mount_uploader :image2, DjangoPictureUploader
  mount_uploader :image3, DjangoPictureUploader
  mount_uploader :image4, DjangoPictureUploader
  mount_uploader :image5, DjangoPictureUploader

  attribute :id, :uuid, default: -> { SecureRandom.uuid }

  validates :collection_code,
            numericality: {
              only_integer: true,
              greater_than_or_equal_to: 0,
              less_than_or_equal_to: 999_999_999_999_999_999
            }

  validates :identified_by, length: { maximum: 18 }, allow_blank: true
  validates :collecter,     length: { maximum: 18 }, allow_blank: true

  validates :date_identified, presence: true

  validates :year,
            numericality: {
              only_integer: true,
              greater_than_or_equal_to: 0,
              less_than_or_equal_to: 9_999
            }

  validates :month,
            numericality: {
              only_integer: true,
              greater_than_or_equal_to: 0,
              less_than_or_equal_to: 12
            }

  validates :day,
            numericality: {
              only_integer: true,
              greater_than_or_equal_to: 0,
              less_than_or_equal_to: 31
            }

  # M=オス、F=メス、H=両性、I=不確定、U=不明、T=転移
  validates :sex, length: { maximum: 1 }, allow_blank: true

  validates :preparation_type, length: { maximum: 20 }, allow_blank: true

  validates :disposition, length: { maximum: 30 }, allow_blank: true

  validates :sampling_protocol, length: { maximum: 20 }, allow_blank: true

  validates :sampling_effort, length: { maximum: 100 }, allow_blank: true

  validates :lifestage, length: { maximum: 20 }, allow_blank: true

  validates :establishment_means, length: { maximum: 20 }, allow_blank: true

  validates :rights, length: { maximum: 10 }, allow_blank: true

  validates :note, length: { maximum: 200 }, allow_blank: true

  scope :with_taxon_info, -> {
    joins(<<~SQL.squish)
      LEFT JOIN all_taxa AS taxon_info
        ON COALESCE(
             specimens.custom_taxon_info_id,
             specimens.default_taxon_info_id
           ) = taxon_info.id
    SQL
  }

  default_scope do
    with_taxon_info.includes(
      :custom_taxon_info,
      :default_taxon_info,
      :collect_point_info,
      :tour,
      :collection_settings_info
    )
  end

  def taxon_info
    custom_taxon_info.presence || default_taxon_info
  end

  TAXON_COLUMNS = %w[
    kingdom
    phylum
    class_name
    order
    suborder
    family
    subfamily
    tribe
    subtribe
    genus
    subgenus
    species
    subspecies
    scientific_name_author
    name_publishedin_year
    japanese_name
    change_genus_brackets
    unknown_author_brackets
    unknown_name_publishedin_year_brackets
    actual_dist_year
    distribution
    all_taxon_name
    scientific_name
    scientific_and_japanese_name
  ].freeze

  # 動的に「taxon_info_カラム名」メソッドと ransacker を定義
  #
  # これにより、インスタンスメソッド specimen.taxon_info_genus などが呼べ、
  # Ransack でも taxon_info_genus_cont のように書けるようになる。
  TAXON_COLUMNS.each do |col|
    define_method("taxon_info_#{col}") do
      if custom_taxon_info&.all_taxon&.public_send(col).present?
        custom_taxon_info.all_taxon.public_send(col)
      else
        default_taxon_info&.all_taxon&.public_send(col)
      end
    end

    ransacker :"taxon_info_#{col}", formatter: proc { |v| v } do |_parent|
      case col
      when "all_taxon_name"
        Arel.sql(<<~SQL.squish)
          concat_ws(' ',
            taxon_info.kingdom,
            taxon_info.phylum,
            taxon_info.class_name,
            taxon_info.order,
            taxon_info.suborder,
            taxon_info.family,
            taxon_info.subfamily,
            taxon_info.tribe,
            taxon_info.subtribe,
            taxon_info.genus,
            taxon_info.subgenus,
            taxon_info.species,
            taxon_info.subspecies,
            taxon_info.japanese_name
          )
        SQL
      when "scientific_name"
        Arel.sql("concat_ws(' ', taxon_info.genus, taxon_info.species, taxon_info.subspecies)")
      when "scientific_and_japanese_name"
        Arel.sql("concat_ws(' ', taxon_info.genus, taxon_info.species, taxon_info.subspecies, taxon_info.japanese_name)")
      else
        Arel.sql("taxon_info.#{col}")
      end
    end
  end

  #   - custom_taxon_info が存在すればそちらを優先
  #   - custom_taxon_info がなく default_taxon_info が存在すれば default_taxon_info
  #   - どちらもなければ、数値フィールド (name_publishedin_year / actual_dist_year) は 0、
  #     文字列フィールドは空文字を返す
  def make_taxon_field(field_name)
    if custom_taxon_info.present?
      custom_taxon_info.public_send(field_name)
    elsif default_taxon_info.present?
      default_taxon_info.public_send(field_name)
    else
      %w[name_publishedin_year actual_dist_year].include?(field_name.to_s) ? 0 : ""
    end
  end

  # 各種分類学的プロパティをメソッドとして定義
  def kingdom
    make_taxon_field("kingdom")
  end

  def phylum
    make_taxon_field("phylum")
  end

  # メソッド名が Ruby の予約語 'class' と競合するため、Django の `class_name` をそのまま使用
  def class_name
    make_taxon_field("class_name")
  end

  def order
    make_taxon_field("order")
  end

  def suborder
    make_taxon_field("suborder")
  end

  def family
    make_taxon_field("family")
  end

  def subfamily
    make_taxon_field("subfamily")
  end

  def tribe
    make_taxon_field("tribe")
  end

  def subtribe
    make_taxon_field("subtribe")
  end

  def genus
    make_taxon_field("genus")
  end

  def subgenus
    make_taxon_field("subgenus")
  end

  def species
    make_taxon_field("species")
  end

  def subspecies
    make_taxon_field("subspecies")
  end

  def scientific_name_author
    make_taxon_field("scientific_name_author")
  end

  def name_publishedin_year
    make_taxon_field("name_publishedin_year")
  end

  def japanese_name
    make_taxon_field("japanese_name")
  end

  def change_genus_brackets
    make_taxon_field("change_genus_brackets")
  end

  def unknown_author_brackets
    make_taxon_field("unknown_author_brackets")
  end

  def unknown_name_publishedin_year_brackets
    make_taxon_field("unknown_name_publishedin_year_brackets")
  end

  def actual_dist_year
    make_taxon_field("actual_dist_year")
  end

  # 日本語地名詳細（collect_point_info があればそちらから。それ以外は空文字）
  def japanese_place_name_detail
    collect_point_info.present? ? collect_point_info.japanese_place_name_detail : ""
  end

  # 標本のラベル表示や文字列表現。Django の __str__／name プロパティ相当
  #   - collection_settings_info があれば institution_code と連番、
  #     その後に genus, species, subspecies, japanese_name, japanese_place_name_detail を含める
  #   - なければ "Collection: ? 000000" のようにプレフィックスだけ出力
  def name
    code_str = collection_code.to_s.rjust(6, "0")
    if collection_settings_info.present?
      inst_code = collection_settings_info.institution_code
      [
        inst_code,
        code_str,
        genus,
        species,
        subspecies,
        japanese_name,
        japanese_place_name_detail
      ].join(" ").squeeze(" ")
    else
      [
        "Collection: ?",
        code_str,
        genus,
        species,
        subspecies,
        japanese_name,
        japanese_place_name_detail
      ].join(" ").squeeze(" ")
    end
  end

  # to_s は標本の識別情報（Django の __str__ 相当）
  def to_s
    code_str = collection_code.to_s.rjust(6, "0")
    if collection_settings_info.present?
      "#{collection_settings_info.institution_code} #{code_str}"
    else
      "Collection: ? #{code_str}"
    end
  end

  ransacker :date_last_modified_date do
    Arel.sql("DATE(date_last_modified)")
  end

  scope :within_distance_from, ->(lat, long, radius) {
    joins(:collect_point_info).merge(
      CollectPoint.within_distance_from(lat.to_f, long.to_f, radius.to_f)
    )
  }

  def self.ransackable_scopes(auth_object = nil)
    %i[within_distance_from]
  end

  def self.ransackable_attributes(auth_object = nil)
    attrs = super(auth_object) + TAXON_COLUMNS.map { |col| "taxon_info_#{col}" }
    attrs.uniq
  end

  def self.ransackable_associations(auth_object = nil)
    %w[
      custom_taxon_info
      default_taxon_info
      custom_taxon_info/all_taxon
      default_taxon_info/all_taxon
      collect_point_info
      collection_settings_info
      tour
    ]
  end

  private

  # 保存前に date_last_modified を現在日時に更新する
  def touch_date_last_modified
    self.date_last_modified = Time.current
  end
end
