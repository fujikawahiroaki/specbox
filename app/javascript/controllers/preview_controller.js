// app/javascript/controllers/preview_controller.js
import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  preview(event) {
    const input = event.target; // file_input
    const index = input.dataset.index; // インデックス取得
    let preview = document.getElementById(`preview_image${index}`); // プレビュー用の画像要素を取得

    // プレビュー用の画像タグが存在しない場合は作成する
    if (!preview) {
      preview = document.createElement("img");
      preview.id = `preview_image${index}`;
      preview.classList.add("img-limited"); // 必要に応じてスタイルを追加
      input.parentElement.insertAdjacentElement("beforebegin", preview); // ファイル入力フィールドの前に挿入
    }

    const file = input.files[0]; // 選択されたファイルを取得

    if (file) {
      const reader = new FileReader();
      reader.onload = (e) => {
        preview.src = e.target.result; // 新しい画像をプレビューとして設定
      };
      reader.readAsDataURL(file); // ファイルをデータURLとして読み込む
    }
  }
}
