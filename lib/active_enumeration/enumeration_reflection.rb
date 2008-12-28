module ActiveEnumeration
  class EnumerationReflection < ActiveRecord::Reflection::MacroReflection
    attr_reader :class_name, :name, :foreign_key, :options
  
    def initialize(name, options = {})
      @name = name.to_s
      @class_name = (options[:class_name] || name).to_s.camelize
      @foreign_key = (options[:foreign_key] || "#{name}_id").to_s
    end
  
    def ==(other_aggregation)
      other_aggregation.is_a?(EnumerationReflection) && other_aggregation.klass == self.klass
    end
  
    def belongs_to?
      true
    end
  
    def klass
      @class_name.constantize
    end
  
    def macro
      :has_enumeration
    end
  end
end