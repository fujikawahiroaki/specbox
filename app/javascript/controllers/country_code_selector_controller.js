import { Controller } from "@hotwired/stimulus";
import { iso3166list } from "./iso3166list";

export default class extends Controller {
  static targets = ["select", "input"];

  connect() {
    // セレクトボックスに国名オプションを動的追加
    this.selectTarget.innerHTML =
      `<option value="">選択してください</option>` +
      iso3166list
        .map(
          (country) =>
            `<option value="${country.name}">${country.name}</option>`
        )
        .join("");
  }

  updateCode() {
    const selectedName = this.selectTarget.value;
    const match = iso3166list.find((c) => c.name === selectedName);
    const newCode = match ? match.id : "";

    this.inputTarget.value = newCode;

    // バリデーション発火のため input イベントを自動送出
    this.inputTarget.dispatchEvent(new Event("input", { bubbles: true }));
  }
}
