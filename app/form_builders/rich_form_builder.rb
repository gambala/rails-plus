class RichFormBuilder < ActionView::Helpers::FormBuilder
  def error_message(field_name, options = {})
    return if field_without_errors?(field_name)
    class_def = options[:class] || 'field-paragraph field-paragraph_danger'
    @template.content_tag :div, message(field_name), class: class_def
  end

  def error_messages(options = {})
    errors = @object.errors.dup
    options[:without].each { |error| errors.delete(error) } if options[:without].present?
    return unless errors.any?
    class_def = options[:class] || 'field-paragraph field-paragraph_danger'
    @template.content_tag :div, errors.full_messages.join('; '), class: class_def
  end

  def label(method, text = nil, options = {}, &block)
    options[:class] ||= 'label'
    super(method, text, options, &block)
  end

  def moderation_message(field_name, options = {})
    return unless @object.moderating_record.send("#{field_name}?")
    class_def = options[:class] || 'field-paragraph'
    message = options[:message] || '* Проверяется модераторами'
    @template.content_tag :div, message, class: class_def
  end

  # Deprecated (Use error_messages 01.06.2019)
  def rest_errors_message(excluded_errors, options = {})
    error_messages(options.merge(without: excluded_errors))
  end

  private

  def field_without_errors?(field_name)
    @object.errors[field_name].blank?
  end

  def message(field_name)
    @object.errors[field_name].join(', ').sub(/^./, &:upcase)
  end
end
