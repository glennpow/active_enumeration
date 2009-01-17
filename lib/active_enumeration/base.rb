module ActiveEnumeration
  class Base
    attr_reader :id, :key, :name

    def initialize(*args)
      options = args.extract_options!
      @key = args.first.to_sym
      @id = @key.to_s.hash
      @name = options.delete(:name) || key.to_s
      options.each do |key, value|
        self.instance_variable_set("@#{key}", value)
        self.class_eval do
          attr_reader key.to_sym
        end
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
      self.all << self.new(key, options)
    end

    def self.[](id_or_key)
      return nil if id_or_key.nil?
      case id_or_key
      when Fixnum
        self.all.detect { |enumerated| enumerated.id == id_or_key }
      else
        self.all.detect { |enumerated| enumerated.key == id_or_key.to_sym }
      end
    end
    
    def method_missing(name, *args)
      args.empty? ? self[name] : super
    end
  end
end