// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "jquery"
import bootstrap from "bootstrap"
import githubAutoCompleteElement from "@github/auto-complete-element"
import Blacklight from "blacklight"

window.addEventListener("message", (event) => {
    console.log("postMessage received");
    console.log(event.data);
    $("#selected-image-index").hide();
    $("#dlselect-info").hide();
    $("#selected-image-index").text(event.data);
});