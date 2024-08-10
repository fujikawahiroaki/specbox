require "test_helper"

class CollectionSettingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @collection_setting = collection_settings(:one)
  end

  test "should get index" do
    get collection_settings_url
    assert_response :success
  end

  test "should get new" do
    get new_collection_setting_url
    assert_response :success
  end

  test "should create collection_setting" do
    assert_difference("CollectionSetting.count") do
      post collection_settings_url, params: { collection_setting: { collection_name: @collection_setting.collection_name, institution_code: @collection_setting.institution_code, latest_collection_code: @collection_setting.latest_collection_code, note: @collection_setting.note, user_id: @collection_setting.user_id } }
    end

    assert_redirected_to collection_setting_url(CollectionSetting.last)
  end

  test "should show collection_setting" do
    get collection_setting_url(@collection_setting)
    assert_response :success
  end

  test "should get edit" do
    get edit_collection_setting_url(@collection_setting)
    assert_response :success
  end

  test "should update collection_setting" do
    patch collection_setting_url(@collection_setting), params: { collection_setting: { collection_name: @collection_setting.collection_name, institution_code: @collection_setting.institution_code, latest_collection_code: @collection_setting.latest_collection_code, note: @collection_setting.note, user_id: @collection_setting.user_id } }
    assert_redirected_to collection_setting_url(@collection_setting)
  end

  test "should destroy collection_setting" do
    assert_difference("CollectionSetting.count", -1) do
      delete collection_setting_url(@collection_setting)
    end

    assert_redirected_to collection_settings_url
  end
end
