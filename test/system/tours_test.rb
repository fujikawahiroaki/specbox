require "application_system_test_case"

class ToursTest < ApplicationSystemTestCase
  setup do
    @tour = tours(:one)
  end

  test "visiting the index" do
    visit tours_url
    assert_selector "h1", text: "Tours"
  end

  test "should create tour" do
    visit tours_url
    click_on "New tour"

    fill_in "End date", with: @tour.end_date
    fill_in "Image1", with: @tour.image1
    fill_in "Image2", with: @tour.image2
    fill_in "Image3", with: @tour.image3
    fill_in "Image4", with: @tour.image4
    fill_in "Image5", with: @tour.image5
    fill_in "Note", with: @tour.note
    fill_in "Start date", with: @tour.start_date
    fill_in "Title", with: @tour.title
    fill_in "Track", with: @tour.track
    fill_in "User", with: @tour.user_id
    click_on "Create Tour"

    assert_text "Tour was successfully created"
    click_on "Back"
  end

  test "should update Tour" do
    visit tour_url(@tour)
    click_on "Edit this tour", match: :first

    fill_in "End date", with: @tour.end_date
    fill_in "Image1", with: @tour.image1
    fill_in "Image2", with: @tour.image2
    fill_in "Image3", with: @tour.image3
    fill_in "Image4", with: @tour.image4
    fill_in "Image5", with: @tour.image5
    fill_in "Note", with: @tour.note
    fill_in "Start date", with: @tour.start_date
    fill_in "Title", with: @tour.title
    fill_in "Track", with: @tour.track
    fill_in "User", with: @tour.user_id
    click_on "Update Tour"

    assert_text "Tour was successfully updated"
    click_on "Back"
  end

  test "should destroy Tour" do
    visit tour_url(@tour)
    click_on "Destroy this tour", match: :first

    assert_text "Tour was successfully destroyed"
  end
end
