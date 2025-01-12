import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["tooltip"];

  show() {
    const tooltip = this.tooltipTarget;
    const linkRect = this.element.getBoundingClientRect(); // リンク要素の位置を取得

    // ツールチップの位置を画面全体で指定するためにpositionをfixedに変更
    tooltip.style.position = "fixed";
    tooltip.style.top = `${linkRect.top + window.scrollY}px`;  // リンクの上端
    tooltip.style.left = `${linkRect.right + window.scrollX + 5}px`; // リンクの右端（5pxの余白を追加）

    // ツールチップを表示
    tooltip.classList.remove("hidden");
  }

  hide() {
    // ツールチップを非表示
    this.tooltipTarget.classList.add("hidden");
  }
}
