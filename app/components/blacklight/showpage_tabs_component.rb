module Blacklight
  class ShowpageTabsComponent < Blacklight::Component
    #include ApplicationHelper;

    def initialize(document)
      @document = document[:document]
    end

    attr_reader :document

    def document_field_exists?(doc,field)
      return false if doc[field].nil? or !doc.has_key?(field) or doc[field][0]==""
      return true
    end

    def render_exhibitions_tab(doc)
      exhs = []
      sorted = doc["exhibition_history_ss"].sort_by { |d|
        #puts d
        extract_date2(d)
        #extract_date2(d[d.index("(")..-1]) # use limit: nil instead
      }
      sorted.reverse!

      if doc["exhibitionURL_ss"]
        sorted2 = doc["exhibitionURL_ss"].sort_by.with_index { |e,i|
          extract_date2(doc["exhibition_history_ss"][i])
        }
        sorted2.reverse!
      end
      sorted.each_with_index {  |exh, i|
        param = URI.encode_www_form_component(exh)

        if sorted2 && sorted2[i] != '-'
          website = sorted2[i]
        end
        #exhs.append("<p><a href=\"/?f[exhibition_history_ss][]=#{param}\">#{exh}</a></p>")
        exhs.append("<p>#{exh} <span style=\"white-space:nowrap\">[<a href=\"/?f[exhibition_history_ss][]=#{param.gsub(';','%3B').gsub('&','%26')}\" target='_blank'>YCBA Objects in the Exhibition</a>]</span>")
        exhs.append(" <span style=\"white-space:nowrap\">[<a href=\"#{website}\" target='_blank'>Exhibition Description</a>]</span>") if website
        exhs.append("</p>")
      }
      exhs.join.html_safe
    end

    def render_lido_citation_presorted_tab(doc)
      presorted_citation = doc["linked_citation_ss"]
      presorted_citation_links = doc["citationURL_ss"]
      combined_with_links = presorted_citation.each_with_index.map { |v,i|
        v2 = v.split("|")
        citation = ""
        ils = ""
        oclc = ""
        callnum = ""
        v2.each_with_index { |part,ii|
          if ii == 0
            citation = part
          else
            if part.starts_with?("a")
              ils = part[1..-1]
            elsif part.starts_with?("b")
              oclc = part[1..-1]
            elsif part.starts_with?("c")
              callnum = part[1..-1]
            end
          end
        }
        if presorted_citation_links.nil? || presorted_citation_links[i].nil? || presorted_citation_links[i] == "-"
          if callnum.include?("(YCBA)") && ils.length > 0
            "<p>#{citation}</i> [<a target=\"_blank\" href=\"https://collections.britishart.yale.edu/catalog/orbis:#{ils}\">YCBA</a>]</p>"
          elsif ils.length > 0
            "<p>#{citation}</i> [<a target=\"_blank\" href=\"https://hdl.handle.net/10079/bibid/#{ils}\">ORBIS</a>]</p>"
          elsif oclc.length > 0
            "<p>#{citation}</i> [<a target=\"_blank\" href=\"http://www.worldcat.org/oclc/#{oclc}\">OCLC</a>]</p>"
          else
            "<p>#{citation}</i></p>"
          end
        else
          "<p>#{v2[0]}</i> [<a target=\"_blank\" href=\"#{presorted_citation_links[i]}\">Website</a>]</p>"
        end
      }
      combined_with_links.join(' ').html_safe
    end

    def extract_date2(d)
      if d.match(/(\b\d{1,2}\D{0,3})?\b(?:Jan(?:uary)?|Feb(?:ruary)?|Mar(?:ch)?|Apr(?:il)?|May|Jun(?:e)?|Jul(?:y)?|Aug(?:ust)?|Sep(?:tember)?|Oct(?:ober)?|(Nov|Dec)(?:ember)?)\D?(\d{1,2}\D?)?\D?((19[1-9]\d|20\d{2})|\d{2})/)
        convert_date(d.match(/(\b\d{1,2}\D{0,3})?\b(?:Jan(?:uary)?|Feb(?:ruary)?|Mar(?:ch)?|Apr(?:il)?|May|Jun(?:e)?|Jul(?:y)?|Aug(?:ust)?|Sep(?:tember)?|Oct(?:ober)?|(Nov|Dec)(?:ember)?)\D?(\d{1,2}\D?)?\D?((19[1-9]\d|20\d{2})|\d{2})/)[0])
      elsif d.match(/\d{4}\-(0?[1-9]|1[012])\-(0?[1-9]|[12][0-9]|3[01])/)
        Date.parse(d,limit: nil)
      else
        Date.parse "9999-12-31"
      end
    end

    def information_link_subject(document)
      subject = "[Online Collection] #{field_value(document,:callnumber_txt)}, #{field_value(document,:title_txt)}, #{field_value(document,:author_ss)} "
    end

    def information_link_subject_on_view(document)
      subject = "[Onview Request] #{field_value(document,:callnumber_txt)}, #{field_value(document,:title_txt)}, #{field_value(document,:author_ss)} "
    end

    def field_value(document, field)
      value = document[field][0] if document[field]
      value ||= ''
    end

    def referenced_works?(document)
      solr_config = Rails.application.config_for(:blacklight)
      solr = RSolr.connect :url => solr_config["url"]
      response = solr.post "select", :params => {
          :fq=>"ilsnumber_ss:\"#{document["id"].gsub("orbis:","")}\"", :rows=>0
      }
      return false if response['response']['numFound'] == 0
      return true
    end

    def format_contents_tab(document)
      s = "<ul style='list-style: disc; margin-left: 15px;'>"
      document["marc_contents_ss"].each do |s1|
        a = s1.split(" -- ")
        a.each do |s2|
          s = s + "<li>" + s2 + "</li>"
        end
      end
      s = s + "</ul>"
      s.html_safe
    end

    def link_to_referenced_ycba_objects(id)
      num_found = get_num_found("ilsnumber_ss",id.gsub("orbis:",""))
      prelabel = "View the"
      label = "Works referenced in this item"
      label = "Work referenced in this item" if num_found == 1
      link_to "#{prelabel} #{num_found} #{label}","#{request.protocol}#{request.host_with_port}/?utf8=✓&search_field=Fielded&q=ilsnumber_ss%3A#{id.gsub("orbis:","")}",target: :_blank, rel: "nofollow"
    end

    def get_num_found(field,value)
      solr_config = Rails.application.config_for(:blacklight)
      solr = RSolr.connect :url => solr_config["url"]
      response = solr.post "select", :params => {
          :fq=>"#{field}:\"#{value}\"", :rows=>0
      }
      response['response']['numFound']
    end

  end
end