module CollectPointsHelper
  def iso_country_label(code)
    country = ISO3166::Country[code]
    return code if country.nil?

    ja_name = country.translations["ja"]
    ja_name.present? ? "#{code}（#{ja_name}）" : code
  end
end
