import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["latitude", "longitude"]

  getLocation(event) {
    event.preventDefault()

    if (!navigator.geolocation) {
      alert("このブラウザでは現在地取得がサポートされていません。")
      return
    }

    navigator.geolocation.getCurrentPosition(
      (position) => {
        const lat = position.coords.latitude.toFixed(6)
        const lon = position.coords.longitude.toFixed(6)

        if (this.hasLatitudeTarget) this.latitudeTarget.value = lat
        if (this.hasLongitudeTarget) this.longitudeTarget.value = lon
      },
      (error) => {
        alert("現在地の取得に失敗しました: " + error.message)
      },
      {
        enableHighAccuracy: true,
        timeout: 10000,
        maximumAge: 0
      }
    )
  }
}
