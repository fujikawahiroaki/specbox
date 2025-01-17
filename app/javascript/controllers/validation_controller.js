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
    const integerMessage = input.dataset.validationMessageInteger;
    const decimalMessage = input.dataset.validationMessageDecimal;
    const minIntegerDigits = parseInt(
      input.dataset.validationMinIntegerDigits || 0
    );
    const maxIntegerDigits = parseInt(
      input.dataset.validationMaxIntegerDigits || 0
    );
    const maxDecimalDigits = parseInt(
      input.dataset.validationMaxDecimalDigits || 0
    );
    const allowNegative = input.dataset.validationAllowNegative === "true";
    const minValue = parseFloat(input.dataset.validationMinValue || -Infinity);
    const maxValue = parseFloat(input.dataset.validationMaxValue || Infinity);
    const validationType = input.dataset.validationType; // validationType の取得

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

    // 数値のバリデーション（整数または少数）
    if (validationType === "integer" || validationType === "decimal") {
      // 整数チェック
      if (
        validationType === "integer" &&
        !this.isInteger(value, allowNegative)
      ) {
        errorMessage = integerMessage;
      }
      // 少数チェック
      else if (
        validationType === "decimal" &&
        !this.isDecimal(value, allowNegative)
      ) {
        errorMessage = decimalMessage;
      }
      // 整数桁数チェック
      if (
        validationType === "integer" &&
        this.isInteger(value, allowNegative)
      ) {
        const integerPart = value.split(".")[0];
        if (integerPart.length < minIntegerDigits) {
          errorMessage = `整数部分は${minIntegerDigits}桁以上で入力してください。`;
        }
        if (integerPart.length > maxIntegerDigits) {
          errorMessage = `整数部分は${maxIntegerDigits}桁以内で入力してください。`;
        }
      }
      // 少数桁数チェック
      if (
        validationType === "decimal" &&
        this.isDecimal(value, allowNegative)
      ) {
        const [integerPart, decimalPart] = value.split(".");
        if (decimalPart.length > maxDecimalDigits) {
          errorMessage = `小数部分は${maxDecimalDigits}桁以内で入力してください。`;
        }
      }
      // 最小値・最大値チェック
      if (value && !this.isWithinRange(value, minValue, maxValue)) {
        errorMessage = `値は${minValue}から${maxValue}の範囲内で入力してください。`;
      }
    }

    // 日付フィールドのバリデーション
    if (validationType === "date") {
      if (required && !value) {
        errorMessage = requiredMessage;
      } else if (value && !this.isValidDate(value)) {
        errorMessage =
          input.dataset.validationMessageInvalid || "無効な日付です";
      }
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
      this.submitTarget.classList.remove("submit-button");
      this.submitTarget.classList.add("submit-button-disabled");
    } else {
      this.submitTarget.disabled = false;
      this.submitTarget.classList.remove("submit-button-disabled");
      this.submitTarget.classList.add("submit-button");
    }
  }

  // 整数チェック関数（厳密な整数チェック）
  isInteger(value, allowNegative) {
    // 整数の正規表現：整数部分のみ、任意桁数の数字（負の整数も許可）
    const regex = allowNegative ? /^-?\d+$/ : /^\d+$/;
    return regex.test(value);
  }

  // 少数チェック関数（厳密な少数チェック）
  isDecimal(value, allowNegative) {
    // 少数の正規表現：整数部分と小数点以下の部分（負の少数も許可）
    const regex = allowNegative ? /^-?\d+\.\d+$/ : /^\d+\.\d+$/;
    return regex.test(value);
  }

  // 数値が指定した範囲内かをチェック
  isWithinRange(value, minValue, maxValue) {
    const num = parseFloat(value);
    return num >= minValue && num <= maxValue;
  }

  // 有効な日付かどうかをチェック
  isValidDate(value) {
    const date = new Date(value);
    return !isNaN(date.getTime());
  }
}
