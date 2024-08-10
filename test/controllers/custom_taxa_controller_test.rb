require "test_helper"

class CustomTaxaControllerTest < ActionDispatch::IntegrationTest
  setup do
    @custom_taxon = custom_taxa(:one)
  end

  test "should get index" do
    get custom_taxa_url
    assert_response :success
  end

  test "should get new" do
    get new_custom_taxon_url
    assert_response :success
  end

  test "should create custom_taxon" do
    assert_difference("CustomTaxon.count") do
      post custom_taxa_url, params: { custom_taxon: { is_private: @custom_taxon.is_private, user_id: @custom_taxon.user_id } }
    end

    assert_redirected_to custom_taxon_url(CustomTaxon.last)
  end

  test "should show custom_taxon" do
    get custom_taxon_url(@custom_taxon)
    assert_response :success
  end

  test "should get edit" do
    get edit_custom_taxon_url(@custom_taxon)
    assert_response :success
  end

  test "should update custom_taxon" do
    patch custom_taxon_url(@custom_taxon), params: { custom_taxon: { is_private: @custom_taxon.is_private, user_id: @custom_taxon.user_id } }
    assert_redirected_to custom_taxon_url(@custom_taxon)
  end

  test "should destroy custom_taxon" do
    assert_difference("CustomTaxon.count", -1) do
      delete custom_taxon_url(@custom_taxon)
    end

    assert_redirected_to custom_taxa_url
  end
end
