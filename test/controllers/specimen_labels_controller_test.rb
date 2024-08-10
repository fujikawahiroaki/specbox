require "test_helper"

class SpecimenLabelsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @specimen_label = specimen_labels(:one)
  end

  test "should get index" do
    get specimen_labels_url
    assert_response :success
  end

  test "should get new" do
    get new_specimen_label_url
    assert_response :success
  end

  test "should create specimen_label" do
    assert_difference("SpecimenLabel.count") do
      post specimen_labels_url, params: { specimen_label: { coll_label_flag: @specimen_label.coll_label_flag, data_label_flag: @specimen_label.data_label_flag, det_label_flag: @specimen_label.det_label_flag, name: @specimen_label.name, note_label_flag: @specimen_label.note_label_flag, user_id: @specimen_label.user_id } }
    end

    assert_redirected_to specimen_label_url(SpecimenLabel.last)
  end

  test "should show specimen_label" do
    get specimen_label_url(@specimen_label)
    assert_response :success
  end

  test "should get edit" do
    get edit_specimen_label_url(@specimen_label)
    assert_response :success
  end

  test "should update specimen_label" do
    patch specimen_label_url(@specimen_label), params: { specimen_label: { coll_label_flag: @specimen_label.coll_label_flag, data_label_flag: @specimen_label.data_label_flag, det_label_flag: @specimen_label.det_label_flag, name: @specimen_label.name, note_label_flag: @specimen_label.note_label_flag, user_id: @specimen_label.user_id } }
    assert_redirected_to specimen_label_url(@specimen_label)
  end

  test "should destroy specimen_label" do
    assert_difference("SpecimenLabel.count", -1) do
      delete specimen_label_url(@specimen_label)
    end

    assert_redirected_to specimen_labels_url
  end
end
