import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    // This method will run when the controller is connected to the element
    connect() {
        // Get the element that has the data-hello-target attribute
            //let element = this.targets.find("hello")
        // Add a class to the element
            //element.classList.add("new-class")
        console.log("doing javascript!!");
    }
}

