import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  preview(event) {
    const input = event.target; // file_input
    const index = input.dataset.index; // インデックス取得
    let preview = document.getElementById(`preview_image${index}`); // プレビュー用の画像要素を取得

    const cancelButton = document.getElementById(`cancel_button${index}`); // 取り消しボタンを取得

    // プレビュー用の画像タグが存在しない場合は作成する
    if (!preview) {
      preview = document.createElement("img");
      preview.id = `preview_image${index}`;
      preview.classList.add("img-limited");
      input.parentElement.insertAdjacentElement("beforebegin", preview); // ファイル入力フィールドの前に挿入
    }

    const file = input.files[0]; // 選択されたファイルを取得

    if (file) {
      // 新しい画像をプレビューとして設定
      const reader = new FileReader();
      reader.onload = (e) => {
        if (preview.originalSrc) {
          preview.dataset.originalSrc = preview.originalSrc;
        }
        preview.src = e.target.result; // 新しい画像をプレビューとして設定
        preview.classList.remove("hidden"); // プレビューを表示
        cancelButton.classList.remove("hidden");
      };
      reader.readAsDataURL(file); // ファイルをデータURLとして読み込む
    }
  }

  cancel(event) {
    const button = event.target; // 取り消しボタン
    const index = button.dataset.index; // インデックス取得
    const input = document.querySelector(`input[data-index="${index}"]`); // 対応する file_input
    const preview = document.getElementById(`preview_image${index}`); // プレビュー画像
    const cancelButton = document.getElementById(`cancel_button${index}`);

    if (input) {
      input.value = ""; // ファイル入力をリセット
    }

    if (preview) {
      preview.src = "";
      const originalSrc = preview.dataset.originalSrc; // 元の画像URL

      cancelButton.classList.add("hidden");

      // 元の画像URLが存在する場合、元の画像を復元
      if (originalSrc) {
        preview.src = originalSrc;
        preview.classList.remove("hidden"); // 元の画像を表示
      } else {
        preview.remove();
      }
    }
  }
}
