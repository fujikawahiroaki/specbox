import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["dropdown"];

  connect() {
    // デフォルトで表示するフィールドのIDをERBから取得
    const defaultVisibleFields = this.element.dataset.defaultVisibleFields
      ? JSON.parse(this.element.dataset.defaultVisibleFields)
      : [];

    // セッションストレージから表示状態を取得
    let filterChoices = JSON.parse(sessionStorage.getItem("filterChoices") || "[]");

    // セッションが空の場合、デフォルト値で初期化
    if (!sessionStorage.getItem("filterChoices")) {
      filterChoices = defaultVisibleFields;
      sessionStorage.setItem("filterChoices", JSON.stringify(filterChoices));
    }

    // フィールドの表示・非表示を切り替え
    this.toggleFields(filterChoices);

    // チェックボックスの状態を更新
    this.updateCheckboxes(filterChoices);
  }

  toggleDropdown() {
    // ドロップダウンをトグル
    const dropdown = this.dropdownTarget;
    dropdown.classList.toggle("hidden");

    // ドロップダウンが開かれた場合、現在の状態をチェックボックスに反映
    if (!dropdown.classList.contains("hidden")) {
      const filterChoices = JSON.parse(sessionStorage.getItem("filterChoices") || "[]");
      this.updateCheckboxes(filterChoices);
    }
  }

  keepDropdownOpen(event) {
    // ドロップダウンが閉じないようにクリックイベントを停止
    event.stopPropagation();
  }

  updateFilter(event) {
    // チェックボックスの変更時に検索項目を表示/非表示
    const checkboxes = this.element.querySelectorAll('input[name="columns[]"]');
    const filterChoices = Array.from(checkboxes)
      .filter((checkbox) => checkbox.checked)
      .map((checkbox) => checkbox.value);

    // フィールドの表示・非表示を更新
    this.toggleFields(filterChoices);

    // セッションストレージに保存
    sessionStorage.setItem("filterChoices", JSON.stringify(filterChoices));
  }

  toggleFields(filterChoices) {
    // IDを基にフィールドを表示/非表示
    const allFields = document.querySelectorAll('[data-filter-choice-field]');
    allFields.forEach((field) => {
      if (filterChoices.includes(field.id)) {
        field.classList.remove("hidden");
      } else {
        field.classList.add("hidden");
      }
    });
  }

  updateCheckboxes(filterChoices) {
    // 現在の状態をチェックボックスに反映
    const checkboxes = this.element.querySelectorAll('input[name="columns[]"]');
    checkboxes.forEach((checkbox) => {
      checkbox.checked = filterChoices.includes(checkbox.value);
    });
  }
}
