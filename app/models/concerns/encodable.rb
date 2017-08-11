require 'active_support/concern'

module Encodable
  extend ActiveSupport::Concern
  
  module ClassMethods
    def firebird_encoding(element)
      element.encode('UTF-8', 'iso-8859-1')
    end
  end
end
