import { Application } from "@hotwired/stimulus";
import PreviewController from "./preview_controller";

const application = Application.start();

// Configure Stimulus development experience
application.debug = false;
window.Stimulus = application;

application.register("preview", PreviewController);

export { application };
