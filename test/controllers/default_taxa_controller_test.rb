require "test_helper"

class DefaultTaxaControllerTest < ActionDispatch::IntegrationTest
  setup do
    @default_taxon = default_taxa(:one)
  end

  test "should get index" do
    get default_taxa_url
    assert_response :success
  end

  test "should get new" do
    get new_default_taxon_url
    assert_response :success
  end

  test "should create default_taxon" do
    assert_difference("DefaultTaxon.count") do
      post default_taxa_url, params: { default_taxon: { is_private: @default_taxon.is_private } }
    end

    assert_redirected_to default_taxon_url(DefaultTaxon.last)
  end

  test "should show default_taxon" do
    get default_taxon_url(@default_taxon)
    assert_response :success
  end

  test "should get edit" do
    get edit_default_taxon_url(@default_taxon)
    assert_response :success
  end

  test "should update default_taxon" do
    patch default_taxon_url(@default_taxon), params: { default_taxon: { is_private: @default_taxon.is_private } }
    assert_redirected_to default_taxon_url(@default_taxon)
  end

  test "should destroy default_taxon" do
    assert_difference("DefaultTaxon.count", -1) do
      delete default_taxon_url(@default_taxon)
    end

    assert_redirected_to default_taxa_url
  end
end
