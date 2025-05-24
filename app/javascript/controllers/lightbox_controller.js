import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  open(event) {
    const src = event.target.getAttribute("data-src");

    // モーダル要素を作成
    const modal = document.createElement("div");
    modal.classList.add(
      "lightbox",
      "fixed",
      "inset-0",
      "z-[2000]",
      "bg-black",
      "bg-opacity-70",
      "flex",
      "justify-center",
      "items-center"
    );

    // モーダルの閉じるボタンを作成
    const closeButton = document.createElement("button");
    closeButton.textContent = "閉じる";
    closeButton.classList.add(
      "absolute",
      "top-4",
      "right-4",
      "bg-white",
      "text-black",
      "p-2",
      "text-lg",
      "font-bold",
      "rounded-md",
      "hover:bg-gray-200",
      "focus:outline-none"
    );
    closeButton.addEventListener("click", () => this.close(modal));

    // 拡大画像を作成
    const image = document.createElement("img");
    image.src = src;
    image.alt = "拡大画像";
    image.classList.add("max-w-screen-md", "max-h-screen-md", "shadow-lg");

    // モーダルにボタンと画像を追加
    modal.appendChild(closeButton);
    modal.appendChild(image);

    // モーダルをbodyに追加
    document.body.appendChild(modal);
  }

  close(modal) {
    // モーダルを削除
    if (modal && modal.parentNode) {
      modal.parentNode.removeChild(modal);
    }
  }
}
