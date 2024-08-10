# Djangoで作ったレガシーデータベースに対応するユーザーモデル
class AuthUser < ApplicationRecord
  self.table_name = "auth_user"
  self.primary_key = "id"
  self.attribute_aliases = { "created_at" => "date_joined" }

  # passwordやemailなどは実際には保存せず、Auth0のsubをusernameとして保存するだけ
  attribute :password, :string, default: ""
  attribute :last_login, :time, default: nil
  attribute :is_superuser, :boolean, default: false
  attribute :first_name, :string, default: ""
  attribute :last_name, :string, default: ""
  attribute :email, :string, default: ""
  attribute :is_staff, :boolean, default: false
  attribute :is_active, :boolean, default: true
end
