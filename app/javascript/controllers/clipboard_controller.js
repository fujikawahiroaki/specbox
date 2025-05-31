import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    text: String
  }

  copy() {
    const content = this.textValue
    if (!navigator.clipboard) {
      // 古いブラウザなどで clipboard API が使えない場合
      console.warn("ブラウザがクリップボード API に対応していません。")
      return
    }

    navigator.clipboard.writeText(content)
      .then(() => {
      })
      .catch((err) => {
        console.error("クリップボードへの書き込みに失敗しました:", err)
      })
  }
}
