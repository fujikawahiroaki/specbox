require "test_helper"

class CollectPointsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @collect_point = collect_points(:one)
  end

  test "should get index" do
    get collect_points_url
    assert_response :success
  end

  test "should get new" do
    get new_collect_point_url
    assert_response :success
  end

  test "should create collect_point" do
    assert_difference("CollectPoint.count") do
      post collect_points_url, params: { collect_point: { contient: @collect_point.contient, coordinate_precision: @collect_point.coordinate_precision, country: @collect_point.country, county: @collect_point.county, image1: @collect_point.image1, image2: @collect_point.image2, image3: @collect_point.image3, image4: @collect_point.image4, image5: @collect_point.image5, island: @collect_point.island, island_group: @collect_point.island_group, japanese_place_name: @collect_point.japanese_place_name, japanese_place_name_detail: @collect_point.japanese_place_name_detail, location: @collect_point.location, maximum_depth: @collect_point.maximum_depth, maximum_elevation: @collect_point.maximum_elevation, minimum_depth: @collect_point.minimum_depth, minimum_elevation: @collect_point.minimum_elevation, municipality: @collect_point.municipality, note: @collect_point.note, state_provice: @collect_point.state_provice, user_id: @collect_point.user_id, verbatim_locality: @collect_point.verbatim_locality } }
    end

    assert_redirected_to collect_point_url(CollectPoint.last)
  end

  test "should show collect_point" do
    get collect_point_url(@collect_point)
    assert_response :success
  end

  test "should get edit" do
    get edit_collect_point_url(@collect_point)
    assert_response :success
  end

  test "should update collect_point" do
    patch collect_point_url(@collect_point), params: { collect_point: { contient: @collect_point.contient, coordinate_precision: @collect_point.coordinate_precision, country: @collect_point.country, county: @collect_point.county, image1: @collect_point.image1, image2: @collect_point.image2, image3: @collect_point.image3, image4: @collect_point.image4, image5: @collect_point.image5, island: @collect_point.island, island_group: @collect_point.island_group, japanese_place_name: @collect_point.japanese_place_name, japanese_place_name_detail: @collect_point.japanese_place_name_detail, location: @collect_point.location, maximum_depth: @collect_point.maximum_depth, maximum_elevation: @collect_point.maximum_elevation, minimum_depth: @collect_point.minimum_depth, minimum_elevation: @collect_point.minimum_elevation, municipality: @collect_point.municipality, note: @collect_point.note, state_provice: @collect_point.state_provice, user_id: @collect_point.user_id, verbatim_locality: @collect_point.verbatim_locality } }
    assert_redirected_to collect_point_url(@collect_point)
  end

  test "should destroy collect_point" do
    assert_difference("CollectPoint.count", -1) do
      delete collect_point_url(@collect_point)
    end

    assert_redirected_to collect_points_url
  end
end
