# frozen_string_literal: true

require 'view_component/version'

module Blacklight
  ##
  #
  # ERJ 11/9/2023 create flavor of  DocumentComponent for show page
  # https://github.com/projectblacklight/blacklight/blob/v8.1.0/app/components/blacklight/document_component.rb
  #
  # A component for rendering a single document
  #
  # @note when subclassing this component, if you override the initializer,
  #    you must explicitly specify the counter variable `document_counter` even if you don't use it.
  #    Otherwise view_component will not provide the count value when calling the component.
  #
  # @see https://viewcomponent.org/guide/collections.html#collection-counter
  #
  # @example
  #  class MyDocumentComponent < Blacklight::DocumentComponent
  #    def initialize(document_counter: nil, **kwargs)
  #      super
  #      ... custom code ...
  #    end
  #  end
  class ShowpageDocumentComponent < Blacklight::Component
    with_collection_parameter :document

    # ViewComponent 3 changes iteration counters to begin at 0 rather than 1
    COLLECTION_INDEX_OFFSET = ViewComponent::VERSION::MAJOR < 3 ? 0 : 1

    renders_one :header, (lambda do
        content_tag :h3, "Learning Viewcomponents"
    end)

    renders_one :image

    renders_one :no_image

    renders_one :metadata, (lambda do
      content_tag :p, @presenter&.view_config
    end)

    renders_one :tabs

    # rubocop:disable Metrics/ParameterLists
    # @param document [Blacklight::DocumentPresenter]
    # @param presenter [Blacklight::DocumentPresenter] alias for document
    # @param partials [Array, nil] view partial names that should be used to provide content for the `partials` slot
    # @param id [String] HTML id for the root element
    # @param classes [Array, String] additional HTML classes for the root element
    # @param component [Symbol, String] HTML tag type to use for the root element
    # @param title_component [Symbol, String] HTML tag type to use for the title element
    # @param counter [Number, nil] a pre-computed counter for the position of this document in a search result set
    # @param document_counter [Number, nil] provided by ViewComponent collection iteration
    # @param counter_offset [Number] the offset of the start of the collection counter parameter for the component to the overall result set
    # @param show [Boolean] are we showing only a single document (vs a list of search results); used for backwards-compatibility
    def initialize(document: nil, presenter: nil, partials: nil,
                   id: nil, classes: [], component: :article, title_component: nil,
                   counter: nil, document_counter: nil, counter_offset: 0,
                   show: false, **args)
      Blacklight.deprecation.warn('the `presenter` argument to DocumentComponent#initialize is deprecated; pass the `presenter` in as document instead') if presenter

      @presenter = presenter || document || args[self.class.collection_parameter]
      @document = @presenter.document
      @view_partials = partials || []

      @component = component
      @title_component = title_component
      @id = id || ('document' if show)
      @classes = classes

      @counter = counter
      @document_counter = document_counter || args.fetch(self.class.collection_counter_parameter, nil)
      @counter ||= @document_counter + COLLECTION_INDEX_OFFSET + counter_offset if @document_counter.present?

      @show = show
    end
    # rubocop:enable Metrics/ParameterLists

    # HTML classes to apply to the root element
    def classes
      [
          @classes,
          helpers.render_document_class(@document),
          'document',
          ("document-position-#{@counter}" if @counter)
      ].compact.flatten
    end

    def before_render
      set_slot(:header, nil) unless header
      set_slot(:image, nil) unless image
      set_slot(:no_image, nil) unless no_image
      set_slot(:metadata, nil) unless metadata
    end

    #with_* methods implemented for compatibility with _show_main_content.html.erb method
    def with_title(as: nil, classes: '', link_to_document: false, actions: false)
    end
    def with_footer
    end

    private

    attr_reader :document_counter, :presenter, :view_partials

    #this showpage_document_component.rb is always show
    def show?
      @show
    end
  end
end