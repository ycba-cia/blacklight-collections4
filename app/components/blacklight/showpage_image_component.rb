# frozen_string_literal: true

module Blacklight
  class ShowpageImageComponent < Blacklight::Component
    include ApplicationHelper;

    def initialize(document)
      @document = document[:document]
    end

    attr_reader :document

    def jsonld
      jsonld_doc = Hash.new
      jsonld_doc["@context"] = "https://schema.org"
      jsonld_doc["@type"] = "VisualArtwork" if document[:recordtype_ss][0] == "lido"
      jsonld_doc["@type"] = "CreativeWork" if document[:recordtype_ss][0] == "marc"
      jsonld_doc["name"] = document["title_ss"][0] unless document["title_ss"].nil?
      jsonld_doc["image"] = document["manifest_thumbnail_ss"][0] unless document["manifest_thumbnail_ss"].nil?

      creator = Hash.new
      creator["@type"] = "Person"
      creator["name"] = document["loc_naf_author_ss"][0] unless document["loc_naf_author_ss"].nil?
      if document[:recordtype_ss][0] == "marc"
        jsonld_doc["creator"] = creator unless document["loc_naf_author_ss"].nil?
      end
      if document[:recordtype_ss][0] == "lido"
        jsonld_doc["artist"] = creator unless document["loc_naf_author_ss"].nil?
      end
      return jsonld_doc.to_json.html_safe
    end

    def manifest_thumb?
      manifest = "https://manifests.collections.yale.edu/ycba/obj/" + document['id'].split(":")[1] if document['recordtype_ss'][0] == "lido"
      manifest = "https://manifests.collections.yale.edu/ycba/orb/" + document['id'].split(":")[1] if document['recordtype_ss'][0] == "marc"
      #puts "MANIFEST:"+manifest;
      begin
        json = JSON.load(URI.open(manifest))
      rescue
        return true
      end
      height = json["items"][0]["height"]
      width = json["items"][0]["width"]
      if height <= 480 and width <= 480
        return true
      else
        return false
      end
    end

    def cmstype?
      return "obj" if document['recordtype_ss'][0] == "lido"
      return "orb" if document['recordtype_ss'][0] == "marc"
    end

  end
end
