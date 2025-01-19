import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="bulk-action"
export default class extends Controller {
  static targets = [
    "selectRow",
    "selectAllRow",
    "bulkIds",
    "bulkColumns",
    "bulkActionPanel",
  ];
  connect() {
    this.updateCheckAllState();
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
  }

  updateSelectRow() {
    this.updateCheckAllState();
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
  }
}
