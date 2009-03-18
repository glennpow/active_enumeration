module ActiveEnumeration
  class Base
    attr_reader :key, :translate_key

    def initialize(*args)
      options = args.extract_options!
      @key = args.first.to_sym
      @name = options.delete(:name) || key.to_s
      @translate_key = options.delete(:translate_key)
      options.each do |key, value|
        self.instance_variable_set("@#{key}", value)
        self.class_eval do
          attr_reader key.to_sym
        end
      end
    end
    
    def name
      @translate_key ? I18n.t(@translate_key, :default => @name) : @name
    end
    
    def to_s
      key.to_s
    end
    
    def to_yaml(options = {})
      key.to_s
    end
    
    def ==(value)
      case value
      when String, Symbol
        self.key == value.to_sym
      when ActiveEnumeration::Base
        self.key == value.key
      else
        false
      end
    end

    def self.all(options = {})
      values = read_inheritable_attribute(:values)
      write_inheritable_attribute(:values, values = []) if values.nil?
      if options[:order]
        order_by, order_in = options[:order].scan(/\w+/).map(&:downcase)
        order_asc = (order_in || 'asc') == 'asc'
        values.sort! { |a, b| (order_asc ? a : b).send(order_by) <=> (order_asc ? b : a).send(order_by) }
      end
      values
    end

    def self.find(key, options = {})
      case key
      when :all
        self.all(options)
      when :first
        self.all(options).first
      when :last
        self.all(options).last
      else
        self[key]
      end
    end

    def self.has_enumerated(key, options = {})
      enumerated = self.new(key, options)
      self.all << enumerated
      (class << self; self; end).instance_eval do
        define_method "#{key}" do
          enumerated
        end
      end
    end

    def self.[](key)
      return nil if key.nil?
      self.all.detect { |enumerated| enumerated.key == key.to_sym }
    end
  end
end