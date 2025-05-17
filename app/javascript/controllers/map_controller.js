import { Controller } from "@hotwired/stimulus"
import L from "leaflet"
import "leaflet-css" // CSSをインポート

L.Icon.Default.imagePath = "/assets/leaflet/"

export default class extends Controller {
  static values = {
    latitude: Number,
    longitude: Number
  }

  connect() {
    if (!this.latitudeValue || !this.longitudeValue) return;

    // 地図の生成と設定
    this.map = L.map(this.element).setView([this.latitudeValue, this.longitudeValue], 13)

    // タイルレイヤー
    L.tileLayer("https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", {
      attribution: "© OpenStreetMap contributors"
    }).addTo(this.map)

    // ピンを立てる
    L.marker([this.latitudeValue, this.longitudeValue]).addTo(this.map)
  }
}
