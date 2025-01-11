import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    setTimeout(() => {
      const flashMessage = document.getElementById('flash-message');
      if (flashMessage) {
        flashMessage.classList.add('opacity-0');
        setTimeout(() => flashMessage.remove(), 100);
      }
    }, 3000);
  }
}
