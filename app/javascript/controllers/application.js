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

export { application };
