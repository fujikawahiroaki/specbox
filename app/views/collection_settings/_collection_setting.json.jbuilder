json.extract! collection_setting, :id, :collection_name, :institution_code, :latest_collection_code, :note, :user_id, :created_at, :updated_at
json.url collection_setting_url(collection_setting, format: :json)
