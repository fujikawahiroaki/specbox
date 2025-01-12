import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["sidebar"];

  connect() {
    // デバイスの画面幅に応じて初期状態を設定
    const isMobileOrTablet = window.innerWidth <= 1024;
    
    // タブレット以下ではサイドバーを閉じる、PCでは開く
    if (isMobileOrTablet) {
      this.sidebarOpen = false; // サイドバーは閉じる
    } else {
      this.sidebarOpen = true; // サイドバーは開く
    }

    this.mainContent = document.getElementById("main-content");

    // サイドバーの初期状態に応じたクラスを設定
    if (this.sidebarOpen) {
      this.sidebarTarget.classList.add("sidebar-open");
      this.sidebarTarget.classList.remove("sidebar-closed");
      this.mainContent.classList.add("ml-56");
    } else {
      this.sidebarTarget.classList.add("sidebar-closed");
      this.sidebarTarget.classList.remove("sidebar-open");
      this.mainContent.classList.remove("ml-56");
    }
  }

  toggle() {
    if (this.sidebarTarget) {
      // サイドバーの開閉をトグル
      this.sidebarTarget.classList.toggle("sidebar-closed");
      this.sidebarTarget.classList.toggle("sidebar-open");
      this.sidebarOpen = !this.sidebarOpen;

      // メインコンテンツの左位置を調整
      if (this.sidebarOpen) {
        this.mainContent.classList.add("ml-56");
      } else {
        this.mainContent.classList.remove("ml-56");
      }

      // サイドバーの開閉状態をsessionStorageに保存
      sessionStorage.setItem("sidebarState", this.sidebarOpen ? "open" : "closed");
    }
  }
}

/**
import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["sidebar"];

  connect() {
    this.sidebarOpen =
      this.sidebarTarget &&
      this.sidebarTarget.classList.contains("sidebar-open");
    this.mainContent = document.getElementById("main-content");
  }

  toggle() {
    // サイドバーの開閉をトグル
    if (this.sidebarTarget) {
      this.sidebarTarget.classList.toggle("sidebar-closed");
      this.sidebarTarget.classList.toggle("sidebar-open");
      this.sidebarOpen = !this.sidebarOpen;

      // メインコンテンツの左位置を調整
      if (this.sidebarOpen) {
        this.mainContent.classList.add("ml-64");
      } else {
        this.mainContent.classList.remove("ml-64");
      }
    }
  }
}
*/
