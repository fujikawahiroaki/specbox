class CollectPoint < ApplicationRecord
  include ImagePath

  self.table_name = "collect_points"
  self.primary_key = "id"

  # ISO3166-1 alpha2国名コード全ての配列
  @@iso_3166_1_alpha2_all = ISO3166::Country.codes

  belongs_to :auth_user, foreign_key: :user_id

  has_many :collect_points_tours, class_name: "CollectPointsTour", foreign_key: "collectpoint_id", dependent: :destroy
  has_many :tours, through: :collect_points_tours

  mount_uploader :image1, DjangoPictureUploader
  mount_uploader :image2, DjangoPictureUploader
  mount_uploader :image3, DjangoPictureUploader
  mount_uploader :image4, DjangoPictureUploader
  mount_uploader :image5, DjangoPictureUploader

  attribute :id, :uuid, default: -> { SecureRandom.uuid }
  # 以下、分類データのカラムをGBIFベースで定義
  # カラム項目はDarwin Core 1.2に概ね準拠
  # カラム名はDarwin Core 1.2をPEP8準拠の表記に変更したもの
  # 名前がよりシンプルになるものは一部Darwin Core 最新版に準拠
  # 以下、コメント内ではDarwin CoreをDCと略記

  # 大陸
  # 正しい綴りは continent だが、Djangoで最初に実装した際にtypoしてしまったので、面倒を避けるためにカラム名はそのまま
  validates :contient, length: { minimum: 0, maximum: 20 }, exclusion: { in: [ nil ] }
  # 島郡
  validates :island_group, length: { minimum: 0, maximum: 30 }, exclusion: { in: [ nil ] }
  # 島
  validates :island, length: { minimum: 0, maximum: 24 }, exclusion: { in: [ nil ] }
  # 国名コード(ISO 3166-1基準の2文字のコード)
  validates :country, length: { is: 2 }, inclusion: { in: @@iso_3166_1_alpha2_all }, exclusion: { in: [ nil ] }
  # 州・県に相当
  validates :state_provice, length: { minimum: 0, maximum: 30 }, exclusion: { in: [ nil ] }
  # 海外における郡・区に相当
  validates :county, length: { minimum: 0, maximum: 30 }, exclusion: { in: [ nil ] }
  # 市名以下の詳細行政地名
  validates :municipality, length: { minimum: 0, maximum: 50 }, exclusion: { in: [ nil ] }
  # 採集地の自由な説明
  validates :verbatim_locality, length: { minimum: 0, maximum: 200 }, exclusion: { in: [ nil ] }
  # 日本語地名(オリジナル)
  validates :japanese_place_name, length: { minimum: 0, maximum: 14 }, exclusion: { in: [ nil ] }
  # 日本語地名詳細(オリジナル)
  validates :japanese_place_name_detail, length: { minimum: 0, maximum: 50 }, exclusion: { in: [ nil ] }
  # 採集地の範囲(緯度・経度座標を囲んだ地域の半径をメートル単位で指定)
  validates :coordinate_precision, numericality: { greater_than_or_equal_to: 0 }, exclusion: { in: [ nil ] }
  # 採集地の最低海抜距離(メートル)
  validates :minimum_elevation, exclusion: { in: [ nil ] }
  # 採集地の最高海抜距離(メートル)
  validates :maximum_elevation, exclusion: { in: [ nil ] }
  # 採集地の水面からの最浅の距離(メートル)
  validates :minimum_depth, exclusion: { in: [ nil ] }
  # 採集地の水面からの最深の距離(メートル)
  validates :maximum_depth, exclusion: { in: [ nil ] }
  # 以下、オリジナルの定義
  # 備考
  validates :note, length: { minimum: 0, maximum: 200 }, exclusion: { in: [ nil ] }

  ransacker :created_at_date do
    Arel.sql("DATE(created_at)")
  end

  ransacker :english_place_name do
    Arel.sql("concat_ws(', ', NULLIF('', contient), NULLIF('', island_group), NULLIF('', island), NULLIF('', country), NULLIF('', state_provice), NULLIF('', county), NULLIF('', municipality))")
  end

  ransacker :all_place_name do
    Arel.sql("concat_ws(', ', contient, island_group, island, country, state_provice, county, municipality, verbatim_locality, japanese_place_name, japanese_place_name_detail)")
  end

  def english_place_name
    [ country, contient, island_group, island, state_provice, county, municipality ].select! { |name| name.nil?.! && name.size != 0 }.join(", ")
  end

  def longitude
    location ? location.longitude : nil
  end

  def latitude
    location ? location.latitude : nil
  end

  def self.ransackable_attributes(auth_object = nil)
    [
      "id",
      "created_at",
      "contient",
      "island_group",
      "island",
      "country",
      "state_provice",
      "county",
      "municipality",
      "verbatim_locality",
      "japanese_place_name",
      "japanese_place_name_detail",
      "coordinate_precision",
      "location",
      "minimum_elevation",
      "maximum_elevation",
      "minimum_depth",
      "maximum_depth",
      "note",
      "image1",
      "image2",
      "image3",
      "image4",
      "image5",
      "created_at_date",
      "all_place_name",
      "english_place_name"
    ]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end
end
