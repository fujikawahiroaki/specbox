require "application_system_test_case"

class CollectPointsTest < ApplicationSystemTestCase
  setup do
    @collect_point = collect_points(:one)
  end

  test "visiting the index" do
    visit collect_points_url
    assert_selector "h1", text: "Collect points"
  end

  test "should create collect point" do
    visit collect_points_url
    click_on "New collect point"

    fill_in "Contient", with: @collect_point.contient
    fill_in "Coordinate precision", with: @collect_point.coordinate_precision
    fill_in "Country", with: @collect_point.country
    fill_in "County", with: @collect_point.county
    fill_in "Image1", with: @collect_point.image1
    fill_in "Image2", with: @collect_point.image2
    fill_in "Image3", with: @collect_point.image3
    fill_in "Image4", with: @collect_point.image4
    fill_in "Image5", with: @collect_point.image5
    fill_in "Island", with: @collect_point.island
    fill_in "Island group", with: @collect_point.island_group
    fill_in "Japanese place name", with: @collect_point.japanese_place_name
    fill_in "Japanese place name detail", with: @collect_point.japanese_place_name_detail
    fill_in "Location", with: @collect_point.location
    fill_in "Maximum depth", with: @collect_point.maximum_depth
    fill_in "Maximum elevation", with: @collect_point.maximum_elevation
    fill_in "Minimum depth", with: @collect_point.minimum_depth
    fill_in "Minimum elevation", with: @collect_point.minimum_elevation
    fill_in "Municipality", with: @collect_point.municipality
    fill_in "Note", with: @collect_point.note
    fill_in "State provice", with: @collect_point.state_provice
    fill_in "User", with: @collect_point.user_id
    fill_in "Verbatim locality", with: @collect_point.verbatim_locality
    click_on "Create Collect point"

    assert_text "Collect point was successfully created"
    click_on "Back"
  end

  test "should update Collect point" do
    visit collect_point_url(@collect_point)
    click_on "Edit this collect point", match: :first

    fill_in "Contient", with: @collect_point.contient
    fill_in "Coordinate precision", with: @collect_point.coordinate_precision
    fill_in "Country", with: @collect_point.country
    fill_in "County", with: @collect_point.county
    fill_in "Image1", with: @collect_point.image1
    fill_in "Image2", with: @collect_point.image2
    fill_in "Image3", with: @collect_point.image3
    fill_in "Image4", with: @collect_point.image4
    fill_in "Image5", with: @collect_point.image5
    fill_in "Island", with: @collect_point.island
    fill_in "Island group", with: @collect_point.island_group
    fill_in "Japanese place name", with: @collect_point.japanese_place_name
    fill_in "Japanese place name detail", with: @collect_point.japanese_place_name_detail
    fill_in "Location", with: @collect_point.location
    fill_in "Maximum depth", with: @collect_point.maximum_depth
    fill_in "Maximum elevation", with: @collect_point.maximum_elevation
    fill_in "Minimum depth", with: @collect_point.minimum_depth
    fill_in "Minimum elevation", with: @collect_point.minimum_elevation
    fill_in "Municipality", with: @collect_point.municipality
    fill_in "Note", with: @collect_point.note
    fill_in "State provice", with: @collect_point.state_provice
    fill_in "User", with: @collect_point.user_id
    fill_in "Verbatim locality", with: @collect_point.verbatim_locality
    click_on "Update Collect point"

    assert_text "Collect point was successfully updated"
    click_on "Back"
  end

  test "should destroy Collect point" do
    visit collect_point_url(@collect_point)
    click_on "Destroy this collect point", match: :first

    assert_text "Collect point was successfully destroyed"
  end
end
