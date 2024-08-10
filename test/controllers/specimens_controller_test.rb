require "test_helper"

class SpecimensControllerTest < ActionDispatch::IntegrationTest
  setup do
    @specimen = specimens(:one)
  end

  test "should get index" do
    get specimens_url
    assert_response :success
  end

  test "should get new" do
    get new_specimen_url
    assert_response :success
  end

  test "should create specimen" do
    assert_difference("Specimen.count") do
      post specimens_url, params: { specimen: { allow_kojin_shuzo: @specimen.allow_kojin_shuzo, collect_point_info_id: @specimen.collect_point_info_id, collecter: @specimen.collecter, collection_code: @specimen.collection_code, collection_settings_info_id: @specimen.collection_settings_info_id, custom_taxon_info_id: @specimen.custom_taxon_info_id, date_identified: @specimen.date_identified, date_last_modified: @specimen.date_last_modified, day: @specimen.day, default_taxon_info_id: @specimen.default_taxon_info_id, disposition: @specimen.disposition, establishment_means: @specimen.establishment_means, identified_by: @specimen.identified_by, image1: @specimen.image1, image2: @specimen.image2, image3: @specimen.image3, image4: @specimen.image4, image5: @specimen.image5, lifestage: @specimen.lifestage, month: @specimen.month, note: @specimen.note, preparation_type: @specimen.preparation_type, published_kojin_shuzo: @specimen.published_kojin_shuzo, rights: @specimen.rights, sampling_effort: @specimen.sampling_effort, sampling_protocol: @specimen.sampling_protocol, sex: @specimen.sex, tour_id: @specimen.tour_id, user_id: @specimen.user_id, year: @specimen.year } }
    end

    assert_redirected_to specimen_url(Specimen.last)
  end

  test "should show specimen" do
    get specimen_url(@specimen)
    assert_response :success
  end

  test "should get edit" do
    get edit_specimen_url(@specimen)
    assert_response :success
  end

  test "should update specimen" do
    patch specimen_url(@specimen), params: { specimen: { allow_kojin_shuzo: @specimen.allow_kojin_shuzo, collect_point_info_id: @specimen.collect_point_info_id, collecter: @specimen.collecter, collection_code: @specimen.collection_code, collection_settings_info_id: @specimen.collection_settings_info_id, custom_taxon_info_id: @specimen.custom_taxon_info_id, date_identified: @specimen.date_identified, date_last_modified: @specimen.date_last_modified, day: @specimen.day, default_taxon_info_id: @specimen.default_taxon_info_id, disposition: @specimen.disposition, establishment_means: @specimen.establishment_means, identified_by: @specimen.identified_by, image1: @specimen.image1, image2: @specimen.image2, image3: @specimen.image3, image4: @specimen.image4, image5: @specimen.image5, lifestage: @specimen.lifestage, month: @specimen.month, note: @specimen.note, preparation_type: @specimen.preparation_type, published_kojin_shuzo: @specimen.published_kojin_shuzo, rights: @specimen.rights, sampling_effort: @specimen.sampling_effort, sampling_protocol: @specimen.sampling_protocol, sex: @specimen.sex, tour_id: @specimen.tour_id, user_id: @specimen.user_id, year: @specimen.year } }
    assert_redirected_to specimen_url(@specimen)
  end

  test "should destroy specimen" do
    assert_difference("Specimen.count", -1) do
      delete specimen_url(@specimen)
    end

    assert_redirected_to specimens_url
  end
end
