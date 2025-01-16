import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="incremental-search"
export default class extends Controller {
  connect() {
    this.timeout = null
  }

  submit() {
    clearTimeout(this.timeout)

    this.timeout = setTimeout(() => {
      this.element.requestSubmit()
    }, 300)
  }
}
