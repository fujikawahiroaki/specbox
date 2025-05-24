import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static values = {
    modelName: String,
    formModelName: String,
    searchPath: String,
    displayField: String,
    valueField: { type: String, default: "id" },
    associationType: { type: String, default: "many_to_many" }, // or "has_one", "has_many"
    initialItems: Array,
  };

  static targets = ["searchInput", "results", "selectedList"];

  connect() {
    this.selectedItems = new Map();
    if (this.hasInitialItemsValue) {
      this.initialItemsValue.forEach(({ id, label }) => {
        this.selectedItems.set(id, label);
      });
      this.renderSelected();
    }
    console.log(this.initialItemsValue);
  }

  search(event) {
    if (event.key === "Enter") event.preventDefault();

    const query = this.searchInputTarget.value.trim();
    if (query.length < 1) {
      this.resultsTarget.innerHTML = "";
      return;
    }

    const selectedIds = Array.from(this.selectedItems.keys());
    const url = new URL(this.searchPathValue, window.location.origin);
    url.searchParams.set("q", query);
    selectedIds.forEach((id) => url.searchParams.append("selected_ids[]", id));

    fetch(url, {
      headers: { Accept: "text/vnd.turbo-stream.html" },
    })
      .then((response) => response.text())
      .then((html) => {
        const fragment = document.createRange().createContextualFragment(html);
        document.body.appendChild(fragment);
      });
  }

  select(event) {
    const item = event.currentTarget.dataset;
    const id = item.value;
    const label = item.label;

    if (this.selectedItems.has(id)) {
      return; // 二重追加防止
    }

    if (this.associationTypeValue === "has_one") {
      this.selectedItems.clear();
    }

    this.selectedItems.set(id, label);
    this.renderSelected();

    // クリア
    this.resultsTarget.innerHTML = "";
    this.searchInputTarget.value = "";
  }

  remove(event) {
    const id = event.currentTarget.dataset.value;
    this.selectedItems.delete(id);
    this.renderSelected();
  }

  renderSelected() {
    // 表示領域を初期化
    this.selectedListTarget.innerHTML = "";

    for (const [id, label] of this.selectedItems.entries()) {
      // ラッパー要素を作成
      const wrapper = document.createElement("div");
      wrapper.className =
        "flex items-center bg-blue-100 text-blue-800 rounded px-2 py-1 text-sm mb-1";

      // フォーム送信用 name を動的に決定
      const inputName = this.inputName();

      wrapper.innerHTML = `
      <span class="mr-2">${label}</span>
      <button
        type="button"
        data-action="association-selector#remove"
        data-value="${id}"
        class="text-red-500 hover:text-red-700 ml-1"
        title="削除"
        aria-label="削除"
      >
        &times;
      </button>
      <input type="hidden" name="${inputName}" value="${id}">
    `;

      this.selectedListTarget.appendChild(wrapper);
    }

    // 選択ゼロ時に空配列送信用 hidden input を追加
    if (this.selectedItems.size === 0) {
      const placeholder = document.createElement("input");
      placeholder.type = "hidden";
      placeholder.name = this.inputName();
      placeholder.value = "";
      this.selectedListTarget.appendChild(placeholder);
    }
  }

  inputName() {
    const assoc = this.modelNameValue;
    const formModel = this.formModelNameValue;

    if (this.associationTypeValue === "has_one") {
      return `${formModel}[${assoc}_id]`;
    } else {
      return `${formModel}[${assoc}_ids][]`;
    }
  }
}
