require "application_system_test_case"

class CustomTaxaTest < ApplicationSystemTestCase
  setup do
    @custom_taxon = custom_taxa(:one)
  end

  test "visiting the index" do
    visit custom_taxa_url
    assert_selector "h1", text: "Custom taxa"
  end

  test "should create custom taxon" do
    visit custom_taxa_url
    click_on "New custom taxon"

    check "Is private" if @custom_taxon.is_private
    fill_in "User", with: @custom_taxon.user_id
    click_on "Create Custom taxon"

    assert_text "Custom taxon was successfully created"
    click_on "Back"
  end

  test "should update Custom taxon" do
    visit custom_taxon_url(@custom_taxon)
    click_on "Edit this custom taxon", match: :first

    check "Is private" if @custom_taxon.is_private
    fill_in "User", with: @custom_taxon.user_id
    click_on "Update Custom taxon"

    assert_text "Custom taxon was successfully updated"
    click_on "Back"
  end

  test "should destroy Custom taxon" do
    visit custom_taxon_url(@custom_taxon)
    click_on "Destroy this custom taxon", match: :first

    assert_text "Custom taxon was successfully destroyed"
  end
end
