import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["input", "error", "submit"];

  connect() {
    // ページ読み込み時に全フィールドをバリデーション
    this.validateAll();

    // 各入力フィールドにリアルタイムバリデーションを設定
    this.inputTargets.forEach((input) => {
      input.addEventListener("input", this.validate.bind(this));
    });
  }

  validate(event) {
    const input = event.target;
    this.validateField(input); // 入力中のリアルタイムバリデーション
  }

  validateAll() {
    // ページ読み込み時に全フィールドをバリデーション
    this.inputTargets.forEach((input) => this.validateField(input));
  }

  validateField(input) {
    const value = input.value;
    const required = input.dataset.validationRequired === "true";
    const minLength = parseInt(input.dataset.validationMinLength || 0);
    const maxLength = parseInt(input.dataset.validationMaxLength || 0);
    const regex = input.dataset.validationRegex;
    const requiredMessage = input.dataset.validationMessageRequired;
    const lengthMessage = input.dataset.validationMessageLength;
    const regexMessage = input.dataset.validationMessageRegex;

    let errorMessage = "";

    // 必須チェック
    if (required && !value) {
      errorMessage = requiredMessage;
    }
    // 最小文字数チェック
    else if (minLength && value.length < minLength) {
      errorMessage = lengthMessage;
    }
    // 最大文字数チェック
    else if (maxLength && value.length > maxLength) {
      errorMessage = lengthMessage;
    }
    // 正規表現チェック
    else if (regex && !new RegExp(regex).test(value)) {
      errorMessage = regexMessage;
    }

    const errorElement = input
      .closest("div")
      .querySelector("[data-validation-target='error']");

    // エラーメッセージ表示/非表示
    if (errorMessage) {
      errorElement.textContent = errorMessage;
      errorElement.classList.remove("hidden"); // エラー表示
      input.dataset.valid = "false"; // フィールドが無効
    } else {
      errorElement.textContent = "";
      errorElement.classList.add("hidden"); // エラー非表示
      input.dataset.valid = "true"; // フィールドが有効
    }

    this.toggleSubmitButton();
  }

  toggleSubmitButton() {
    // フィールドがすべて有効かチェック
    const invalidFields = this.inputTargets.filter(
      (input) => input.dataset.valid === "false" || !input.dataset.valid
    );

    if (invalidFields.length > 0) {
      this.submitTarget.disabled = true;
      this.submitTarget.classList.add("bg-gray-400", "cursor-not-allowed"); // 無効時のスタイル
    } else {
      this.submitTarget.disabled = false;
      this.submitTarget.classList.remove("bg-gray-400", "cursor-not-allowed"); // 有効時のスタイル
    }
  }
}
