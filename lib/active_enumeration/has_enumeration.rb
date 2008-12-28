module ActiveEnumeration
  module HasEnumeration
    def self.included(base)
      base.extend(MacroMethods)
    end
  
    module MacroMethods
      def has_enumeration(name, options = {})
        unless self.is_a? ActiveEnumeration::HasEnumeration::ClassMethods
          extend ActiveEnumeration::HasEnumeration::ClassMethods
        end

        reflection = ActiveEnumeration::EnumerationReflection.new(name, options)
        self.reflect_on_all_enumerations << reflection

        class_eval do
          define_method name do
            reflection.klass[self.send(reflection.foreign_key)]
          end
        
          define_method "#{name}=" do |value|
            enumerate = case value
            when Enumeration
              value
            else
              reflection.klass[value]
            end
            self.send("#{reflection.foreign_key}=", enumerate.id)
          end
        end
      end
    end
  
    module ClassMethods
      def reflect_on_all_enumerations
        reflections = read_inheritable_attribute(:enumerations)
        write_inheritable_attribute(:enumerations, reflections = []) if reflections.nil?
        reflections
      end
    
      def reflect_on_enumeration(name)
        self.reflect_on_all_enumerations.detect { |reflection| reflection.name == name.to_s }
      end
    end
  end
end

ActiveRecord::Base.send(:include, ActiveEnumeration::HasEnumeration)