require "application_system_test_case"

class AuthUsersTest < ApplicationSystemTestCase
  setup do
    @auth_user = auth_users(:one)
  end

  test "visiting the index" do
    visit auth_users_url
    assert_selector "h1", text: "Auth users"
  end

  test "should create auth user" do
    visit auth_users_url
    click_on "New auth user"

    fill_in "Date joined", with: @auth_user.date_joined
    fill_in "Email", with: @auth_user.email
    fill_in "First name", with: @auth_user.first_name
    check "Is active" if @auth_user.is_active
    check "Is staff" if @auth_user.is_staff
    check "Is superuser" if @auth_user.is_superuser
    fill_in "Last login", with: @auth_user.last_login
    fill_in "Last name", with: @auth_user.last_name
    fill_in "Password", with: @auth_user.password
    fill_in "Username", with: @auth_user.username
    click_on "Create Auth user"

    assert_text "Auth user was successfully created"
    click_on "Back"
  end

  test "should update Auth user" do
    visit auth_user_url(@auth_user)
    click_on "Edit this auth user", match: :first

    fill_in "Date joined", with: @auth_user.date_joined
    fill_in "Email", with: @auth_user.email
    fill_in "First name", with: @auth_user.first_name
    check "Is active" if @auth_user.is_active
    check "Is staff" if @auth_user.is_staff
    check "Is superuser" if @auth_user.is_superuser
    fill_in "Last login", with: @auth_user.last_login
    fill_in "Last name", with: @auth_user.last_name
    fill_in "Password", with: @auth_user.password
    fill_in "Username", with: @auth_user.username
    click_on "Update Auth user"

    assert_text "Auth user was successfully updated"
    click_on "Back"
  end

  test "should destroy Auth user" do
    visit auth_user_url(@auth_user)
    click_on "Destroy this auth user", match: :first

    assert_text "Auth user was successfully destroyed"
  end
end
