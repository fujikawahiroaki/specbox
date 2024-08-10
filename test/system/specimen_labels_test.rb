require "application_system_test_case"

class SpecimenLabelsTest < ApplicationSystemTestCase
  setup do
    @specimen_label = specimen_labels(:one)
  end

  test "visiting the index" do
    visit specimen_labels_url
    assert_selector "h1", text: "Specimen labels"
  end

  test "should create specimen label" do
    visit specimen_labels_url
    click_on "New specimen label"

    check "Coll label flag" if @specimen_label.coll_label_flag
    check "Data label flag" if @specimen_label.data_label_flag
    check "Det label flag" if @specimen_label.det_label_flag
    fill_in "Name", with: @specimen_label.name
    check "Note label flag" if @specimen_label.note_label_flag
    fill_in "User", with: @specimen_label.user_id
    click_on "Create Specimen label"

    assert_text "Specimen label was successfully created"
    click_on "Back"
  end

  test "should update Specimen label" do
    visit specimen_label_url(@specimen_label)
    click_on "Edit this specimen label", match: :first

    check "Coll label flag" if @specimen_label.coll_label_flag
    check "Data label flag" if @specimen_label.data_label_flag
    check "Det label flag" if @specimen_label.det_label_flag
    fill_in "Name", with: @specimen_label.name
    check "Note label flag" if @specimen_label.note_label_flag
    fill_in "User", with: @specimen_label.user_id
    click_on "Update Specimen label"

    assert_text "Specimen label was successfully updated"
    click_on "Back"
  end

  test "should destroy Specimen label" do
    visit specimen_label_url(@specimen_label)
    click_on "Destroy this specimen label", match: :first

    assert_text "Specimen label was successfully destroyed"
  end
end
