require "application_system_test_case"

class DefaultTaxaTest < ApplicationSystemTestCase
  setup do
    @default_taxon = default_taxa(:one)
  end

  test "visiting the index" do
    visit default_taxa_url
    assert_selector "h1", text: "Default taxa"
  end

  test "should create default taxon" do
    visit default_taxa_url
    click_on "New default taxon"

    check "Is private" if @default_taxon.is_private
    click_on "Create Default taxon"

    assert_text "Default taxon was successfully created"
    click_on "Back"
  end

  test "should update Default taxon" do
    visit default_taxon_url(@default_taxon)
    click_on "Edit this default taxon", match: :first

    check "Is private" if @default_taxon.is_private
    click_on "Update Default taxon"

    assert_text "Default taxon was successfully updated"
    click_on "Back"
  end

  test "should destroy Default taxon" do
    visit default_taxon_url(@default_taxon)
    click_on "Destroy this default taxon", match: :first

    assert_text "Default taxon was successfully destroyed"
  end
end
