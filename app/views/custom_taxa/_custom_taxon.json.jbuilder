json.extract! custom_taxon, :id, :is_private, :user_id, :created_at, :updated_at
json.url custom_taxon_url(custom_taxon, format: :json)
