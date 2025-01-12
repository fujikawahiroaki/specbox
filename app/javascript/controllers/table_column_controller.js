import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["dropdown"];

  connect() {
    this.isDropdownOpen = false; // ドロップダウンの状態を初期化
  }

  toggleDropdown() {
    this.isDropdownOpen = !this.isDropdownOpen;
    this.dropdownTarget.classList.toggle("hidden", !this.isDropdownOpen);
  }

  keepDropdownOpen(event) {
    // ドロップダウン内のクリックはイベントを伝播させない
    event.stopPropagation();
  }

  closeDropdown() {
    this.isDropdownOpen = false;
    this.dropdownTarget.classList.add("hidden");
  }
}
