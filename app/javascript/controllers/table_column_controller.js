import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["dropdown"];

  connect() {
    // デフォルトで表示するフィールドのIDをERBから取得
    const defaultVisibleColumns = this.element.dataset.defaultVisibleColumns
      ? JSON.parse(this.element.dataset.defaultVisibleColumns)
      : [];

    // セッションストレージから表示状態を取得
    let visibleColumns = JSON.parse(
      sessionStorage.getItem("visibleColumns") || "[]"
    );

    // セッションが空の場合、デフォルト値で初期化
    if (!sessionStorage.getItem("visibleColumns")) {
      visibleColumns = defaultVisibleColumns;
      sessionStorage.setItem("visibleColumns", JSON.stringify(visibleColumns));
    }

    // フィールドの表示・非表示を切り替え
    this.toggleColumns(visibleColumns);

    // チェックボックスの状態を更新
    this.updateCheckboxes(visibleColumns);
  }

  toggleDropdown() {
    // ドロップダウンをトグル
    const dropdown = this.dropdownTarget;
    dropdown.classList.toggle("hidden");

    // ドロップダウンが開かれた場合、現在の状態をチェックボックスに反映
    if (!dropdown.classList.contains("hidden")) {
      const visibleColumns = JSON.parse(
        sessionStorage.getItem("visibleColumns") || "[]"
      );
      this.updateCheckboxes(visibleColumns);
    }
  }

  keepDropdownOpen(event) {
    // ドロップダウンが閉じないようにクリックイベントを停止
    event.stopPropagation();
  }

  updateColumn(event) {
    // チェックボックスの変更時に検索項目を表示/非表示
    const checkboxes = this.element.querySelectorAll('input[name="columns[]"]');
    const visibleColumns = Array.from(checkboxes)
      .filter((checkbox) => checkbox.checked)
      .map((checkbox) => checkbox.value);

    // フィールドの表示・非表示を更新
    this.toggleColumns(visibleColumns);

    // セッションストレージに保存
    sessionStorage.setItem("visibleColumns", JSON.stringify(visibleColumns));
  }

  toggleColumns(visibleColumns) {
    // IDを基にフィールドを表示/非表示
    const allColumns = document.querySelectorAll("[data-table-column-visible-columns]");
    allColumns.forEach((col) => {
      if (visibleColumns.includes(col.id)) {
        col.classList.remove("hidden");
      } else {
        col.classList.add("hidden");
      }
    });
  }

  updateCheckboxes(visibleColumns) {
    // 現在の状態をチェックボックスに反映
    const checkboxes = this.element.querySelectorAll('input[name="columns[]"]');
    checkboxes.forEach((checkbox) => {
      checkbox.checked = visibleColumns.includes(checkbox.value);
    });
  }
}
