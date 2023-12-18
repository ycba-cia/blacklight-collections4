import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    connect() {
        //console.log("does connect() js downloads controller work?");
    }

    select_one_dl() {
        var downloads = this.data.get("downloads");
        downloads = JSON.parse(downloads);
        var id = this.data.get("id");
        var doc1 = this.data.get("doc");
        var doc1 = JSON.parse(doc1);
        //console.log("downloads:", downloads);
        //console.log("id:", id);
        //console.log("doc:", doc1);

        var index = $("#selected-image-index").text();
        $("#dlselect-info").show();
        //console.log("download:" + downloads[index]);
        this.selectdl(downloads[index],id,doc1);
    }

    selectdl(download,id,doc) {
        //console.log ("download:" + download);
        //console.log ("download:" + download[0]);
        //console.log ("download:" + download[1]);
        //console.log ("download:" + download[2]);
        //console.log ("download:" + download[3]);
        //[count,caption,jpeg,tiff]

        var index = download[0]-1
        var jpeg_info = "";
        $("#dlselect-info").text(download[0] + ". "+download[1]);

        //console.log("doc:"+doc);
        //console.log("download:"+download);
        //console.log("id:"+id);

        var recordtype = doc["recordtype_ss"][0];
        if (recordtype=="lido") {
            var cap1 = [];
            if (doc["author_ss"] != null) { cap1.push(doc["author_ss"][0]); }
            if (doc["title_ss"] != null) { cap1.push(doc["title_ss"][0]); }
            //if (download != null) { cap1.push(download[1]); } //don't display caption as of 1/23/2023
            if (doc["publishDate_ss"] != null) { cap1.push(doc["publishDate_ss"][0]); }
            if (doc["format_ss"] != null) { cap1.push(doc["format_ss"][0]); }
            if (doc["credit_line_ss"] != null) { cap1.push(doc["credit_line_ss"][0]); }
            if (doc["callnumber_ss"] != null) { cap1.push(doc["callnumber_ss"][0]); }
            $("#caption-dl-info").text(cap1.join(", ") + ".");
        }
        if (recordtype=="marc") {
            var cap1 = [];
            if (doc["author_ss"] != null) { cap1.push(doc["author_ss"][0]); }
            if (doc["titles_primary_ss"] != null) { cap1.push(doc["titles_primary_ss"][0]); }
            //if (download != null) { cap1.push(download[1]); }////don't display caption as of 1/23/2023
            if (doc["edition_ss"] != null) { cap1.push(doc["edition_ss"][0]); }
            if (doc["publisher_ss"] != null) { cap1.push(doc["publisher_ss"][0]); }
            if (doc["credit_line_ss"] != null) { cap1.push(doc["credit_line_ss"][0]); }
            $("#caption-dl-info").text(cap1.join(", ") + ".");
        }
        if (download[2].length == 0) {
            jpeg_info += "<a href='" + download[2] + "' download='" + download[1] + "' target=\"_blank\">";
            jpeg_info += "<button id='jpeg-dl-button' type='button' class='btn btn-primary btn-sm' disabled>JPEG</button>";
            jpeg_info += "</a>"
        } else {
            if (download[4] > 1024) {
                var dl2 = download[2].replace("/full/full", "/full/,1024");
            } else {
                var dl2 = download[2];
            }
            jpeg_info += "<a href='" + dl2 + "' download='" + download[1] + "' target=\"_blank\">";
            jpeg_info += "<button id='jpeg-dl-button' type='button' class='btn btn-primary btn-sm'>JPEG</button>";
            jpeg_info += "</a>"
            //$("#jpeg-dl-info").text(download[0] + ". "+download[1]); deprecated
        }
        $("#jpeg-container").html(jpeg_info);

        var tiff_info =  "";
        if (download[3].length == 0) {
            tiff_info += "<a href='" + download[3] + "' download='" + download[1] + "' target=\"_blank\">";
            tiff_info += "<button id='tiff-dl-button' type='button' class='btn btn-primary btn-sm' disabled>TIFF</button>";
            tiff_info += "</a>";
        } else {
            tiff_info += "<a href='" + download[3] + "' download='" + download[1] + "' target=\"_blank\">";
            tiff_info += "<button id='tiff-dl-button' type='button' class='btn btn-primary btn-sm'>TIFF</button>";
            tiff_info += "</a>";
            //$("#tiff-dl-info").text(download[0] + ". "+download[1]); deprecated
        }
        $("#tiff-container").html(tiff_info);

        var print_info =  "";
        var print_info_all = "";
        var print_path = "/print/"+id+"/1/"+index+"?caption="+download[1];
        var print_path_all = "/print/"+id+"/9998/9998";
        if (download[2].length == 0) {
            print_info += "<a href='"+print_path+"' target=\"_blank\">";
            print_info += "<button id='print-button' type='button' class='btn btn-primary btn-sm' disabled>Print</button>";
            print_info += "</a>";
            print_info_all += "<a href='"+print_path_all+"' target=\"_blank\">";
            print_info_all += "<button id='print-button-all' type='button' class='btn btn-primary btn-sm' disabled>Print All</button>";
            print_info_all += "</a>";
        } else {
            print_info += "<a href='"+print_path+"' target=\"_blank\">";
            print_info += "<button id='print-button' type='button' class='btn btn-primary btn-sm'>Print</button>";
            print_info += "</a>";
            print_info_all += "<a href='"+print_path_all+"' target=\"_blank\">";
            print_info_all += "<button id='print-button-all' type='button' class='btn btn-primary btn-sm'>Print All</button>";
            print_info_all += "</a>";
            //$("#print-info").text(download[0] + ". "+download[1]);deprecated
        }
        $("#print-container").html(print_info);
        $("#print-container-all").html(print_info_all);

    }

}