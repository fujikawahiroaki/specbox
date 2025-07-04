import { Application } from "@hotwired/stimulus";
import PreviewController from "./preview_controller";
import LightBoxController from "./lightbox_controller";
import ValidationController from "./validation_controller";
import FlashController from "./flash_controller";
import SideBarController from "./sidebar_controller";
import TooltipController from "./tooltip_controller";
import TableColumnController from "./table_column_controller";
import FilterChoiceController from "./filter_choice_controller";
import IncrementalSearchController from "./incremental_search_controller";
import BulkActionController from "./bulk_action_controller";
import BulkUpdateChoiceController from "./bulk_update_choice_controller";
import LeafletMapController from "./map_controller";
import LeafletSelectorController from "./leaflet_selector_controller";
import CountryCodeSelectorController from "./country_code_selector_controller";
import AssociationSelectorController from "./association_selector_controller";
import GeolocationInputController from "./geolocation_input_controller.js_controller";
import ClipboardController from "./clipboard_controller";

const application = Application.start();

// Configure Stimulus development experience
application.debug = false;
window.Stimulus = application;

application.register("preview", PreviewController);
application.register("lightbox", LightBoxController);
application.register("validation", ValidationController);
application.register("flash", FlashController);
application.register("sidebar", SideBarController);
application.register("tooltip", TooltipController);
application.register("table-column", TableColumnController);
application.register("filter-choice", FilterChoiceController);
application.register("incremental-search", IncrementalSearchController);
application.register("bulk-action", BulkActionController);
application.register("bulk-update-choice", BulkUpdateChoiceController);
application.register("leaflet-map", LeafletMapController);
application.register("leaflet-selector", LeafletSelectorController);
application.register("country-code-selector", CountryCodeSelectorController);
application.register("association-selector", AssociationSelectorController);
application.register("geolocation-input", GeolocationInputController);
application.register("clipboard", ClipboardController);

export { application };
