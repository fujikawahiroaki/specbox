import { Controller } from "@hotwired/stimulus";
import L from "leaflet";
import { GeoSearchControl, OpenStreetMapProvider } from "leaflet-geosearch";
import { muniArray } from "./muni_array.js";
import * as hepburn from "hepburn";
import { toHiragana } from "wanakana";

export default class extends Controller {
  static values = {
    latitude: Number,
    longitude: Number,
    zoom: { type: Number, default: 5 },
  };

  static targets = ["map"];

  connect() {
    this.marker = null;
    this.initializeMap();
  }

  initializeMap() {
    const lat = this.latitudeValue ?? 35.681236;
    const lng = this.longitudeValue ?? 139.767125;

    this.map = L.map(this.mapTarget).setView([lat, lng], this.zoomValue);

    L.tileLayer("https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", {
      attribution:
        '&copy; <a href="https://osm.org/copyright">OpenStreetMap</a>',
    }).addTo(this.map);

    this.marker = L.marker([this.latitudeValue, this.longitudeValue], {
      draggable: false,
    }).addTo(this.map);

    this.map.on("click", this.handleMapClick.bind(this));

    this.handleMapClick({
      latlng: {
        lat: lat,
        lng: lng,
      },
    });

    this.map.addControl(
      new GeoSearchControl({
        provider: new OpenStreetMapProvider(),
        style: "bar",
        autoClose: true,
        retainZoomLevel: false,
        animateZoom: true,
        searchLabel: "地名を検索",
        keepResult: true,
        showMarker: false,
        showPopup: false,
      })
    );

    this.map.on("geosearch/showlocation", (result) => {
      const lat = parseFloat(result.location.y || result.location.raw?.lat);
      const lng = parseFloat(result.location.x || result.location.raw?.lon);

      if (!isNaN(lat) && !isNaN(lng)) {
        this.map.setView([lat, lng], this.map.getZoom());

        if (this.marker) {
          this.marker.setLatLng([lat, lng]);
        } else {
          this.marker = L.marker([lat, lng], { draggable: false }).addTo(
            this.map
          );
        }

        this.handleMapClick({ latlng: { lat, lng } });
      } else {
        console.warn("検索結果に緯度経度がありませんでした", result);
      }
    });
  }

  async handleMapClick(event) {
    const lat = event.latlng.lat.toFixed(6);
    const lng = event.latlng.lng.toFixed(6);

    if (this.marker) {
      this.marker.setLatLng([lat, lng]);
    } else {
      this.marker = L.marker([lat, lng], { draggable: false }).addTo(this.map);
    }

    this.latitude = lat;
    this.longitude = lng;

    this.elevation = await this.fetchElevation(lng, lat);
    const place = await this.fetchPlaceNameAndKana(lng, lat);

    this.renderLocationInfo(place);
  }

  async fetchElevation(lng, lat) {
    try {
      const res = await fetch(
        `https://cyberjapandata2.gsi.go.jp/general/dem/scripts/getelevation.php?lon=${lng}&lat=${lat}&outtype=JSON`
      );
      const json = await res.json();
      return json.elevation === "-----"
        ? "取得できませんでした"
        : parseFloat(json.elevation).toFixed(0);
    } catch (e) {
      return "取得できませんでした";
    }
  }

  async fetchPlaceNameAndKana(lng, lat) {
    try {
      const res = await fetch(
        `https://mreversegeocoder.gsi.go.jp/reverse-geocoder/LonLatToAddress?lat=${lat}&lon=${lng}`
      );
      const json = await res.json();
      let muniCd = json.results?.muniCd;
      if (!muniCd) throw new Error("muniCd がありません");
      if (muniCd.startsWith("0")) muniCd = muniCd.slice(1);

      const arr = muniArray[muniCd] || [];
      const pref = arr[1] || "";
      const city = arr[3] || "";
      const detail =
        json.results.lv01Nm?.replace(/^大字/, "").replace(/^字/, "") || "";

      const zipTarget = `${city}${detail}`;
      const zipResponse = await fetch(
        `/collect_points/reverse_zipcode?for_reverce_zipcode=${encodeURIComponent(
          zipTarget
        )}`
      );
      const zipJson = await zipResponse.json();

      const kanaComponents = zipJson.data?.items?.[0]?.componentskana || [];
      const cityKana = toHiragana(kanaComponents[1] || "");
      const detailKana = toHiragana(kanaComponents[2] || "");

      const romajiCity = this.toHebon(cityKana);
      const romajiDetail = this.toHebon(detailKana);

      return {
        latitude: this.latitude,
        longitude: this.longitude,
        elevation: this.elevation,
        cityKana,
        detailKana,
        japanesePlaceName: `${pref} ${city} ${detail}`,
        romaji: `${romajiCity}, ${romajiDetail}`,
      };
    } catch (e) {
      return {
        latitude: this.latitude,
        longitude: this.longitude,
        elevation: this.elevation,
        cityKana: "取得できませんでした",
        detailKana: "取得できませんでした",
        japanesePlaceName: "取得できませんでした",
        romaji: "ローマ字化できませんでした",
      };
    }
  }

  toHebon(kana) {
    if (!kana) return "ローマ字化できませんでした";
    let romaji = hepburn.fromKana(kana).trim().toUpperCase();

    const suffixMap = [
      ["SHI", "-SHI"],
      ["CHO", "-CHŌ"],
      ["MACHI", "-MACHI"],
      ["MURA", "-MURA"],
      ["SON", "-SON"],
      ["KU", "-KU"],
    ];
    for (const [suffix, replacement] of suffixMap) {
      if (romaji.endsWith(suffix)) {
        romaji = romaji.slice(0, -suffix.length) + replacement;
        break;
      }
    }

    if (romaji.includes("GUN, ")) {
      romaji = romaji.replace("GUN, ", "-GUN, ");
      const gunIdx = romaji.indexOf("-GUN, ") + 6;
      romaji =
        romaji.charAt(0) +
        romaji.slice(1, gunIdx).toLowerCase() +
        romaji.charAt(gunIdx) +
        romaji.slice(gunIdx + 1).toLowerCase();
    }

    return this.convertToMacron(
      romaji.charAt(0) + romaji.slice(1).toLowerCase()
    );
  }

  convertToMacron(romaji) {
    return romaji
      .replace(/AA/g, "Ā")
      .replace(/II/g, "Ī")
      .replace(/UU/g, "Ū")
      .replace(/EE/g, "Ē")
      .replace(/OU/g, "Ō")
      .replace(/OO/g, "Ō");
  }

  renderLocationInfo(data) {
    const infoEl = document.getElementById("location-info-display");
    if (!infoEl) return;

    const makeRow = (label, value, targets = []) => {
      const copyBtn = `<button type="button" data-action="leaflet-selector#copy" data-value="${value}" class="px-2 py-1 text-xs rounded bg-blue-500 text-white hover:bg-blue-600 cursor-pointer">コピー</button>`;
      const applyBtns = (Array.isArray(targets) ? targets : [targets])
        .map(
          (target) =>
            `<button type="button" data-action="leaflet-selector#apply" data-target="${target}" data-value="${value}" class="px-2 py-1 text-xs rounded bg-green-500 text-white hover:bg-green-600 cursor-pointer">${this.getApplyLabel(
              target
            )}</button>`
        )
        .join(" ");

      return `
        <div>
          <strong>${label}</strong>: <span>${value}</span>
          <div class="space-x-2 space-y-2">${copyBtn} ${applyBtns}</div>
        </div>
      `;
    };

    const kanaRow = (label, value) => {
      return `<div><strong>${label}</strong>: <span>${value}</span></div>`;
    };

    infoEl.innerHTML = [
      makeRow("緯度", data.latitude, "latitude"),
      makeRow("経度", data.longitude, "longitude"),
      makeRow("標高", `${data.elevation}`, [
        "minimum_elevation",
        "maximum_elevation",
      ]),
      makeRow("日本語地名", data.japanesePlaceName, [
        "japanese_place_name",
        "japanese_place_name_detail",
      ]),
      kanaRow("市町村名の読みがな", data.cityKana),
      kanaRow("地名詳細の読みがな", data.detailKana),
      makeRow("ローマ字地名", data.romaji, "municipality"),
    ].join("");
  }

  getApplyLabel(target) {
    switch (target) {
      case "minimum_elevation":
        return "最低標高に反映";
      case "maximum_elevation":
        return "最高標高に反映";
      case "japanese_place_name":
        return "日本語地名に反映";
      case "japanese_place_name_detail":
        return "日本語地名詳細に反映";
      case "municipality":
        return "ローマ字地名に反映";
      default:
        return "反映";
    }
  }

  copy(event) {
    const value = event.target.dataset.value;
    navigator.clipboard.writeText(value);
  }

  apply(event) {
    const target = event.target.dataset.target;
    const value = event.target.dataset.value;
    const input = document.getElementById(target);
    if (input) {
      input.value = value;

      // バリデーション発火のため input イベントを発火
      input.dispatchEvent(new Event("input", { bubbles: true }));
    }
  }
}
