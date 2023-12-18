import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    connect() {
        //console.log("does connect() js downloads controller work?");
    }
    select_one_dl() {
        console.log("downloads:", this.data.get("downloads"));
        console.log("id:", this.data.get("id"));
        console.log("doc:", this.data.get("doc"));
    }
}