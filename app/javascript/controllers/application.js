import { Application } from "@hotwired/stimulus";
import PreviewController from "./preview_controller";
import LightBoxController from "./lightbox_controller";

const application = Application.start();

// Configure Stimulus development experience
application.debug = false;
window.Stimulus = application;

application.register("preview", PreviewController);
application.register("lightbox", LightBoxController);

export { application };
