module Blacklight
  class Configuration::ShowField < Blacklight::Configuration::DisplayField
    def initialize(*args, **kwargs, &block)
      super

      #self.presenter ||= Blacklight::FieldPresenter
      #this initialize from DisplayField overridding self.component
      self.component = Blacklight::ShowMetadataFieldComponent

    end
  end
end