require "application_system_test_case"

class SpecimensTest < ApplicationSystemTestCase
  setup do
    @specimen = specimens(:one)
  end

  test "visiting the index" do
    visit specimens_url
    assert_selector "h1", text: "Specimens"
  end

  test "should create specimen" do
    visit specimens_url
    click_on "New specimen"

    check "Allow kojin shuzo" if @specimen.allow_kojin_shuzo
    fill_in "Collect point info", with: @specimen.collect_point_info_id
    fill_in "Collecter", with: @specimen.collecter
    fill_in "Collection code", with: @specimen.collection_code
    fill_in "Collection settings info", with: @specimen.collection_settings_info_id
    fill_in "Custom taxon info", with: @specimen.custom_taxon_info_id
    fill_in "Date identified", with: @specimen.date_identified
    fill_in "Date last modified", with: @specimen.date_last_modified
    fill_in "Day", with: @specimen.day
    fill_in "Default taxon info", with: @specimen.default_taxon_info_id
    fill_in "Disposition", with: @specimen.disposition
    fill_in "Establishment means", with: @specimen.establishment_means
    fill_in "Identified by", with: @specimen.identified_by
    fill_in "Image1", with: @specimen.image1
    fill_in "Image2", with: @specimen.image2
    fill_in "Image3", with: @specimen.image3
    fill_in "Image4", with: @specimen.image4
    fill_in "Image5", with: @specimen.image5
    fill_in "Lifestage", with: @specimen.lifestage
    fill_in "Month", with: @specimen.month
    fill_in "Note", with: @specimen.note
    fill_in "Preparation type", with: @specimen.preparation_type
    check "Published kojin shuzo" if @specimen.published_kojin_shuzo
    fill_in "Rights", with: @specimen.rights
    fill_in "Sampling effort", with: @specimen.sampling_effort
    fill_in "Sampling protocol", with: @specimen.sampling_protocol
    fill_in "Sex", with: @specimen.sex
    fill_in "Tour", with: @specimen.tour_id
    fill_in "User", with: @specimen.user_id
    fill_in "Year", with: @specimen.year
    click_on "Create Specimen"

    assert_text "Specimen was successfully created"
    click_on "Back"
  end

  test "should update Specimen" do
    visit specimen_url(@specimen)
    click_on "Edit this specimen", match: :first

    check "Allow kojin shuzo" if @specimen.allow_kojin_shuzo
    fill_in "Collect point info", with: @specimen.collect_point_info_id
    fill_in "Collecter", with: @specimen.collecter
    fill_in "Collection code", with: @specimen.collection_code
    fill_in "Collection settings info", with: @specimen.collection_settings_info_id
    fill_in "Custom taxon info", with: @specimen.custom_taxon_info_id
    fill_in "Date identified", with: @specimen.date_identified
    fill_in "Date last modified", with: @specimen.date_last_modified
    fill_in "Day", with: @specimen.day
    fill_in "Default taxon info", with: @specimen.default_taxon_info_id
    fill_in "Disposition", with: @specimen.disposition
    fill_in "Establishment means", with: @specimen.establishment_means
    fill_in "Identified by", with: @specimen.identified_by
    fill_in "Image1", with: @specimen.image1
    fill_in "Image2", with: @specimen.image2
    fill_in "Image3", with: @specimen.image3
    fill_in "Image4", with: @specimen.image4
    fill_in "Image5", with: @specimen.image5
    fill_in "Lifestage", with: @specimen.lifestage
    fill_in "Month", with: @specimen.month
    fill_in "Note", with: @specimen.note
    fill_in "Preparation type", with: @specimen.preparation_type
    check "Published kojin shuzo" if @specimen.published_kojin_shuzo
    fill_in "Rights", with: @specimen.rights
    fill_in "Sampling effort", with: @specimen.sampling_effort
    fill_in "Sampling protocol", with: @specimen.sampling_protocol
    fill_in "Sex", with: @specimen.sex
    fill_in "Tour", with: @specimen.tour_id
    fill_in "User", with: @specimen.user_id
    fill_in "Year", with: @specimen.year
    click_on "Update Specimen"

    assert_text "Specimen was successfully updated"
    click_on "Back"
  end

  test "should destroy Specimen" do
    visit specimen_url(@specimen)
    click_on "Destroy this specimen", match: :first

    assert_text "Specimen was successfully destroyed"
  end
end
