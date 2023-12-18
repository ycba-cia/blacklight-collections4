import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    // This method will run when the controller is connected to the element
    connect() {
        // Get the element that has the data-hello-target attribute
        //let element = this.targets.find("hello")
        // Add a class to the element
        //element.classList.add("new-class")
        console.log("clipboard div connected to controller!!");
    }

    copy_to_clipboard() {
        //alert(document.getElementById("caption-dl-info").textContent);
        var copyText = document.getElementById("caption-dl-info").textContent.trim();

        /* Select the text field */ /* ERJ not needed */
        //copyText.select();
        //copyText.setSelectionRange(0, 99999); /* For mobile devices */

        /* Copy the text inside the text field */
        navigator.clipboard.writeText(copyText);

        /* Alert the copied text */
        alert("Caption copied.");
    }
}