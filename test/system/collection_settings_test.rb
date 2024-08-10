require "application_system_test_case"

class CollectionSettingsTest < ApplicationSystemTestCase
  setup do
    @collection_setting = collection_settings(:one)
  end

  test "visiting the index" do
    visit collection_settings_url
    assert_selector "h1", text: "Collection settings"
  end

  test "should create collection setting" do
    visit collection_settings_url
    click_on "New collection setting"

    fill_in "Collection name", with: @collection_setting.collection_name
    fill_in "Institution code", with: @collection_setting.institution_code
    fill_in "Latest collection code", with: @collection_setting.latest_collection_code
    fill_in "Note", with: @collection_setting.note
    fill_in "User", with: @collection_setting.user_id
    click_on "Create Collection setting"

    assert_text "Collection setting was successfully created"
    click_on "Back"
  end

  test "should update Collection setting" do
    visit collection_setting_url(@collection_setting)
    click_on "Edit this collection setting", match: :first

    fill_in "Collection name", with: @collection_setting.collection_name
    fill_in "Institution code", with: @collection_setting.institution_code
    fill_in "Latest collection code", with: @collection_setting.latest_collection_code
    fill_in "Note", with: @collection_setting.note
    fill_in "User", with: @collection_setting.user_id
    click_on "Update Collection setting"

    assert_text "Collection setting was successfully updated"
    click_on "Back"
  end

  test "should destroy Collection setting" do
    visit collection_setting_url(@collection_setting)
    click_on "Destroy this collection setting", match: :first

    assert_text "Collection setting was successfully destroyed"
  end
end
