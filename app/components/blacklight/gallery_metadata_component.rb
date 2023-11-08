# frozen_string_literal: true

module Blacklight
  #this is a sibling class of https://github.com/projectblacklight/blacklight/blob/v8.0.1/app/components/blacklight/document_metadata_component.rb
  class GalleryMetadataComponent < Blacklight::Component
    renders_many :fields, (lambda do |component: nil, **kwargs|
      #ERJ 11/8/2023 added layout: Blacklight::GalleryMetadataFieldLayoutComponent on next line
      GalleryMetadataFieldComponent.new(**kwargs, layout: Blacklight::GalleryMetadataFieldLayoutComponent)
    end)
    with_collection_parameter :fields

    # @param fields [Enumerable<Blacklight::FieldPresenter>] Document field presenters
    # rubocop:disable Metrics/ParameterLists
    def initialize(fields: [], tag: 'dl', classes: %w[document-metadata dl-invert row], show: false, view_type: nil, field_layout: nil, **component_args)
      @fields = fields
      @tag = tag
      @classes = classes
      @show = show
      @view_type = view_type
      @field_layout = field_layout
      @component_args = component_args
    end
    # rubocop:enable Metrics/ParameterLists

    def before_render
      return unless fields

      @fields.each do |field|
        with_field(component: field.component, field: field, show: @show, view_type: @view_type, layout: @field_layout)
      end
    end

    def render?
      fields.present?
    end

    attr_reader :view_type
  end
end
