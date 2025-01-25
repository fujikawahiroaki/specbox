import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="bulk-action"
export default class extends Controller {
  static targets = [
    "selectRow",
    "selectAllRow",
    "bulkIds",
    "bulkColumns",
    "bulkUpdateButton",
    "bulkActionPanel",
    "bulkDeleteIds",
    "bulkDeleteButton",
    "selectRowCount",
  ];
  connect() {
    this.updateCheckAllState();
    this.toggleBulkDeleteButton();
    this.toggleBulkUpdateButton();
  }

  bulkUpdate(event) {
    // セッションストレージから表示状態を取得
    const bulkUpdateFields = JSON.parse(
      sessionStorage.getItem("bulkUpdateFields") || "[]"
    );

    const bulkIds = this.selectRowTargets
      .filter((row) => row.checked == true)
      .map((row) => row.value);

    if (bulkIds.length === 0) {
      event.preventDefault();
      alert("一括更新対象のデータが選択されていません");
    }

    this.bulkIdsTarget.value = JSON.stringify(bulkIds);
    this.bulkColumnsTarget.value = JSON.stringify(bulkUpdateFields);
    this.bulkUpdateButtonTarget.classList.add("submit-button-disabled");
    if (this.hasBulkDeleteButtonTarget) {
      this.bulkDeleteButtonTarget.classList.add("submit-button-disabled");
    }
    if (this.hasSelectRowCountTarget) {
      this.selectRowCountTarget.textContent = 0;
    }
  }

  bulkDelete(event) {
    const bulkDeleteIds = this.selectRowTargets
      .filter((row) => row.checked == true)
      .map((row) => row.value);

    if (bulkDeleteIds.length === 0) {
      event.preventDefault();
      alert("一括削除対象のデータが選択されていません");
    }

    this.bulkDeleteIdsTarget.value = JSON.stringify(bulkDeleteIds);
    this.bulkDeleteButtonTarget.classList.add("submit-button-disabled");
    if (this.hasBulkUpdateButtonTarget) {
      this.bulkUpdateButtonTarget.classList.remove("submit-button");
      this.bulkUpdateButtonTarget.classList.add("submit-button-disabled");
    }
    if (this.hasSelectRowCountTarget) {
      this.selectRowCountTarget.textContent = 0;
    }
  }

  toggleBulkDeleteButton() {
    if (this.hasBulkDeleteButtonTarget) {
      this.updateCheckAllState();
      const bulkDeleteIds = this.selectRowTargets
        .filter((row) => row.checked == true)
        .map((row) => row.value);

      if (bulkDeleteIds.length === 0) {
        this.bulkDeleteButtonTarget.classList.add("submit-button-disabled");
      } else {
        this.bulkDeleteButtonTarget.classList.remove("submit-button-disabled");
      }
    }
  }

  toggleBulkUpdateButton() {
    if (this.hasBulkUpdateButtonTarget) {
      const bulkIds = this.selectRowTargets
        .filter((row) => row.checked == true)
        .map((row) => row.value);

      if (bulkIds.length === 0) {
        this.bulkUpdateButtonTarget.classList.remove("submit-button");
        this.bulkUpdateButtonTarget.classList.add("submit-button-disabled");
      } else {
        this.bulkUpdateButtonTarget.classList.remove("submit-button-disabled");
        this.bulkUpdateButtonTarget.classList.add("submit-button");
      }
    }
  }

  zeroSelectDisabledBulkUpdate() {
    if (this.hasBulkUpdateButtonTarget) {
      const bulkIds = this.selectRowTargets
        .filter((row) => row.checked == true)
        .map((row) => row.value);

      if (bulkIds.length === 0) {
        this.bulkUpdateButtonTarget.classList.remove("submit-button");
        this.bulkUpdateButtonTarget.classList.add("submit-button-disabled");
      }
    }
  }

  updateSelectRow() {
    this.updateCheckAllState();

    this.toggleBulkDeleteButton();
    this.toggleBulkUpdateButton();
  }

  updateAllRow() {
    const allChecked = this.selectAllRowTarget.checked;
    this.selectRowTargets.forEach((row) => {
      const actualDOM = document.getElementById(
        `bulk-action-select-row-${row.value}`
      );
      if (actualDOM) {
        actualDOM.checked = allChecked;
      }
    });

    this.updateCheckAllState();

    this.toggleBulkDeleteButton();
    this.toggleBulkUpdateButton();
  }

  resetSelectDisplay() {
    if (this.hasSelectRowCountTarget) {
      this.selectRowCountTarget.textContent = 0;
    }
    if (this.hasBulkUpdateButtonTarget) {
      this.bulkUpdateButtonTarget.classList.remove("submit-button");
      this.bulkUpdateButtonTarget.classList.add("submit-button-disabled");
    }
    if (this.hasBulkDeleteButtonTarget) {
      this.bulkDeleteButtonTarget.classList.add("submit-button-disabled");
    }
  }

  updateCheckAllState() {
    const allChecked = this.selectRowTargets.every(
      (checkbox) => checkbox.checked
    );
    const allUnchecked = this.selectRowTargets.every(
      (checkbox) => !checkbox.checked
    );

    // 「全チェックボックス」のチェック状態を変更
    const checkAllCheckbox = document.getElementById("selectAllRow");
    if (allChecked) {
      checkAllCheckbox.checked = true;
      checkAllCheckbox.indeterminate = false; // すべてが選択されている場合
    } else if (allUnchecked) {
      checkAllCheckbox.checked = false;
      checkAllCheckbox.indeterminate = false; // すべてが選択されていない場合
    } else {
      checkAllCheckbox.checked = false;
      checkAllCheckbox.indeterminate = true; // 一部が選択されている場合
    }

    if (this.hasSelectRowCountTarget) {
      this.selectRowCountTarget.textContent = this.selectRowTargets.filter(
        (row) => row.checked
      ).length;
    }
  }
}
