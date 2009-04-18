module ActiveEnumeration
  class Base
    attr_reader :id, :key, :translate_key
    
    @@editable = false

    def initialize(*args)
      options = args.extract_options!
      @key = args.first.to_sym
      @id = @key.to_s.hash.abs
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
    
    def to_sym
      key
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

    def self.find(id_or_key, options = {})
      case id_or_key
      when :all
        values = read_inheritable_attribute(:values)
        write_inheritable_attribute(:values, values = []) if values.nil?
        if options[:order]
          order_by, order_in = options[:order].scan(/\w+/).map(&:downcase)
          order_asc = (order_in || 'asc') == 'asc'
          values.sort! { |a, b| (order_asc ? a : b).send(order_by) <=> (order_asc ? b : a).send(order_by) }
        end
        values
      when :first
        self.find(:all, options).first
      when :last
        self.find(:all, options).last
      else
        self[id_or_key]
      end
    end
    
    def self.all(options = {})
      self.find(:all, options)
    end

    def self.first(options = {})
      self.find(:first, options)
    end
    
    def self.last(options = {})
      self.find(:last, options)
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
    
    def self.make_editable
      @@editable = true
    end
    
    def self.editable?
      @@editable
    end

    def self.[](id_or_key)
      return nil if id_or_key.blank?
      value = self.all.detect { |enumerated| enumerated.id == id_or_key.to_i || enumerated.key == id_or_key.to_sym }
      if value.nil? && self.editable?
        value = self.new(id_or_key)
      end
      value
    end
  end
end