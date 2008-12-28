module EnumerationHelper
  def enumeration_name(enumeration, default = nil)
    enumeration.nil? ? default : enumeration.name
  end
  alias_method :e, :enumeration_name

  def enumeration_options_for_select(enumeration_class, options = {})
    enumeration_class.find(:all, options.reverse_merge(:order => 'name asc')).map { |enumeration| [ enumeration.name, enumeration.id ] }
  end
  
  def enumeration_select(form_or_record, name, options = {}, html_options = {})
    case form_or_record
    when ActionView::Helpers::FormBuilder
      record_class = form_or_record.object.class
      if record_class.respond_to?(:reflect_on_enumeration) && reflection = record_class.reflect_on_enumeration(name)
        form_or_record.select(reflection.foreign_key, enumeration_options_for_select(reflection.klass, options), options, html_options)
      end
    else
      record_class = form_or_record.class
      if record_class.respond_to?(:reflect_on_enumeration) && reflection = record_class.reflect_on_enumeration(name)
        select(form_or_record, reflection.foreign_key, enumeration_options_for_select(reflection.klass, options), options, html_options)
      end
    end
  end
  
  def enumeration_select_tag(name, enumeration_class, options = {})
    select_tag(name, enumeration_options_for_select(enumeration_class, options), options)
  end
end