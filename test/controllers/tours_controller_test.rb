require "test_helper"

class ToursControllerTest < ActionDispatch::IntegrationTest
  setup do
    @tour = tours(:one)
  end

  test "should get index" do
    get tours_url
    assert_response :success
  end

  test "should get new" do
    get new_tour_url
    assert_response :success
  end

  test "should create tour" do
    assert_difference("Tour.count") do
      post tours_url, params: { tour: { end_date: @tour.end_date, image1: @tour.image1, image2: @tour.image2, image3: @tour.image3, image4: @tour.image4, image5: @tour.image5, note: @tour.note, start_date: @tour.start_date, title: @tour.title, track: @tour.track, user_id: @tour.user_id } }
    end

    assert_redirected_to tour_url(Tour.last)
  end

  test "should show tour" do
    get tour_url(@tour)
    assert_response :success
  end

  test "should get edit" do
    get edit_tour_url(@tour)
    assert_response :success
  end

  test "should update tour" do
    patch tour_url(@tour), params: { tour: { end_date: @tour.end_date, image1: @tour.image1, image2: @tour.image2, image3: @tour.image3, image4: @tour.image4, image5: @tour.image5, note: @tour.note, start_date: @tour.start_date, title: @tour.title, track: @tour.track, user_id: @tour.user_id } }
    assert_redirected_to tour_url(@tour)
  end

  test "should destroy tour" do
    assert_difference("Tour.count", -1) do
      delete tour_url(@tour)
    end

    assert_redirected_to tours_url
  end
end
