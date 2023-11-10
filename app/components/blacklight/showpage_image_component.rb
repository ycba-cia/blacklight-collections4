# frozen_string_literal: true

module Blacklight
  class ShowpageImageComponent < Blacklight::Component

    def initialize(document)
      @document = document[:document]
    end

    attr_reader :document

  end
end
