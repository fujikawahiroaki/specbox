import { Controller } from "@hotwired/stimulus"
import L from "leaflet"
import "leaflet-css"

L.Icon.Default.imagePath = "/assets/leaflet/"

export default class extends Controller {
  static targets = []
  static values = {
    latitude: Number,
    longitude: Number,
    zoom: { type: Number, default: 1 }
  }

  // ⬇️ connect後にDOM全体から探す
  connect() {
    // グローバルにinput[name=latitude]とinput[name=longitude]を探す
    this.latitudeInput = document.querySelector("input[name='collect_point[latitude]']")
    this.longitudeInput = document.querySelector("input[name='collect_point[longitude]']")

    if (!this.latitudeInput || !this.longitudeInput) {
      console.warn("緯度・経度フィールドが見つかりません")
      return
    }

    const latVal = this.latitudeInput.value || this.latitudeValue
    const lngVal = this.longitudeInput.value || this.longitudeValue

    console.log(latVal)

    const defaultZoomLevel = (parseFloat(latVal) == 0 && parseFloat(lngVal) == 0) ? 1 : 13

    const initialLat = latVal ? parseFloat(latVal) : 35.6987  // 秋葉原
    const initialLng = lngVal ? parseFloat(lngVal) : 139.7731

    this.map = L.map(this.element).setView([initialLat, initialLng], defaultZoomLevel)

    L.tileLayer("https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", {
      attribution: "© OpenStreetMap contributors"
    }).addTo(this.map)

    // 既に緯度経度が入力済みなら初期ピンを立てる
    if (latVal && lngVal && parseFloat(latVal) !== 0 && parseFloat(lngVal) !== 0) {
      this.marker = L.marker([initialLat, initialLng], { draggable: true }).addTo(this.map)
      this.marker.on("dragend", this.updateFieldsFromMarker.bind(this))
    }

    this.map.on("click", this.setMarkerFromClick.bind(this))

    setTimeout(() => this.map.invalidateSize(), 100)
  }

  setMarkerFromClick(e) {
    const { lat, lng } = e.latlng

    if (!this.marker) {
      this.marker = L.marker([lat, lng], { draggable: true }).addTo(this.map)
      this.marker.on("dragend", this.updateFieldsFromMarker.bind(this))
    } else {
      this.marker.setLatLng([lat, lng])
    }

    this.setFields(lat, lng)
  }

  updateFieldsFromMarker() {
    const { lat, lng } = this.marker.getLatLng()
    this.setFields(lat, lng)
  }

  setFields(lat, lng) {
    this.latitudeInput.value = lat.toFixed(6)
    this.longitudeInput.value = lng.toFixed(6)
  }

  disconnect() {
    if (this.map) this.map.remove()
  }
}
