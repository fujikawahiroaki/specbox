import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["dropdown", "toggleButton"];

  connect() {
    // ドロップダウン外部クリックをリスン
    document.addEventListener("click", this.closeDropdownOutside.bind(this));

    // デフォルトで表示するフィールドのIDをERBから取得
    const defaultVisibleFields = this.element.dataset
      .defaultBulkUpdateChoiceFields
      ? JSON.parse(this.element.dataset.defaultBulkUpdateChoiceFields)
      : [];

    // セッションストレージから表示状態を取得
    let bulkUpdateFields = JSON.parse(
      sessionStorage.getItem("bulkUpdateFields") || "[]"
    );

    // セッションが空の場合、デフォルト値で初期化
    if (!sessionStorage.getItem("bulkUpdateFields")) {
      bulkUpdateFields = defaultVisibleFields;
      sessionStorage.setItem(
        "bulkUpdateFields",
        JSON.stringify(bulkUpdateFields)
      );
    }

    // フィールドの表示・非表示を切り替え
    this.toggleFields(bulkUpdateFields);

    // チェックボックスの状態を更新
    this.updateCheckboxes(bulkUpdateFields);
  }

  disconnect() {
    // コントローラが切り離された際にイベントリスナーを削除
    document.removeEventListener("click", this.closeDropdownOutside.bind(this));
  }

  closeDropdownOutside(event) {
    // ドロップダウン外をクリックしたら閉じる
    if (
      !this.dropdownTarget.contains(event.target) &&
      !this.toggleButtonTarget.contains(event.target)
    ) {
      this.dropdownTarget.classList.add("hidden");
    }
  }

  toggleDropdown() {
    event.stopPropagation();
    // ドロップダウンをトグル
    const dropdown = this.dropdownTarget;
    dropdown.classList.toggle("hidden");

    // ドロップダウンが開かれた場合、現在の状態をチェックボックスに反映
    if (!dropdown.classList.contains("hidden")) {
      const bulkUpdateFields = JSON.parse(
        sessionStorage.getItem("bulkUpdateFields") || "[]"
      );
      this.updateCheckboxes(bulkUpdateFields);
    }
  }

  keepDropdownOpen(event) {
    // ドロップダウンが閉じないようにクリックイベントを停止
    event.stopPropagation();
  }

  updateChoice(event) {
    // チェックボックスの変更時に検索項目を表示/非表示
    const checkboxes = this.element.querySelectorAll(
      'input[name="bulk-update-fields[]"]'
    );
    const bulkUpdateFields = Array.from(checkboxes)
      .filter((checkbox) => checkbox.checked)
      .map((checkbox) => checkbox.value);

    // フィールドの表示・非表示を更新
    this.toggleFields(bulkUpdateFields);

    // セッションストレージに保存
    sessionStorage.setItem(
      "bulkUpdateFields",
      JSON.stringify(bulkUpdateFields)
    );
  }

  toggleFields(bulkUpdateFields) {
    // IDを基にフィールドを表示/非表示
    const allFields = document.querySelectorAll(
      "[data-bulk-update-choice-field]"
    );
    allFields.forEach((field) => {
      const formInput = field.querySelector(".form-input");
      if (bulkUpdateFields.includes(field.id)) {
        field.classList.remove("hidden");
        formInput.classList.remove("hidden");
      } else {
        field.classList.add("hidden");
        formInput.classList.add("hidden");
      }
    });
  }

  updateCheckboxes(bulkUpdateFields) {
    // 現在の状態をチェックボックスに反映
    const checkboxes = this.element.querySelectorAll(
      'input[name="bulk-update-fields[]"]'
    );
    checkboxes.forEach((checkbox) => {
      checkbox.checked = bulkUpdateFields.includes(checkbox.value);
    });
  }
}
