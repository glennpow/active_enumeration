module EnumerationHelper
  def enumeration_name(enumeration, default = nil)
    enumeration.nil? ? default : enumeration.name
  end
  alias_method :e, :enumeration_name

  def enumeration_options_for_select(enumeration_class, options = {})
    enumeration_class.find(:all, options.reverse_merge(:order => 'name asc')).map { |enumeration| [ enumeration.name, enumeration ] }
  end
  
  def enumeration_select(form_or_record, name, options = {}, html_options = {})
    enumeration_foreign_key = options.delete(:enumeration_foreign_key)
    enumeration_class = options.delete(:enumeration_class)
    
    if (enumeration_foreign_key.nil? || enumeration_class.nil?) && form_or_record.object
      record_class = form_or_record.object.class
      if record_class.respond_to?(:reflect_on_enumeration) && reflection = record_class.reflect_on_enumeration(name)
        enumeration_foreign_key ||= reflection.foreign_key
        enumeration_class ||= reflection.klass
      end
    end
    
    enumeration_foreign_key ||= name.to_sym
    enumeration_class ||= name.to_s.classify.constantize
    
    case form_or_record
    when ActionView::Helpers::FormBuilder
      form_or_record.select(enumeration_foreign_key, enumeration_options_for_select(enumeration_class, options), options, html_options)
    else
      select(form_or_record, enumeration_foreign_key, enumeration_options_for_select(enumeration_class, options), options, html_options)
    end
  end
  
  def enumeration_select_tag(name, enumeration_class, options = {})
    select_tag(name, options_for_select(enumeration_options_for_select(enumeration_class, options)), options)
  end
end

ActionView::Base.send :include, EnumerationHelper if defined?(ActionView::Base)