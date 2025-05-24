# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "leaflet" # @1.9.4
pin "leaflet-css" # @0.1.0
pin "wanakana" # @5.3.1
pin "hepburn" # @1.2.1
pin "bulk-replace" # @0.0.1
