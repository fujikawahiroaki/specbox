json.extract! auth_user, :id, :password, :last_login, :is_superuser, :username, :first_name, :last_name, :email, :is_staff, :is_active, :date_joined, :created_at, :updated_at
json.url auth_user_url(auth_user, format: :json)
