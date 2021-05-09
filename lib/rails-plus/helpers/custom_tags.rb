module RailsPlus::Helpers::CustomTags
  # Functions

  def classnames(classes)
    classes.select { |_key, value| value == true }.keys.join(' ')
  end

  # Tags

  def div_tag(*args, &block)
    options = args.extract_options!
    options[:class] = classnames(options[:class]) if options[:class].is_a?(Hash)
    content_tag :div, block_given? ? capture(&block) : args[0], options
  end

  def field_tag(resource, field_name)
    return if resource.public_send(field_name).blank?
    div_tag resource.class.human_attribute_name(field_name)
  end

  def field_tags(resource, *field_names)
    field_names.each { |field_name| concat field_tag(resource, field_name) }
    nil
  end

  def span_tag(*args, &block)
    options = args.extract_options!
    options[:class] = classnames(options[:class]) if options[:class].is_a?(Hash)
    content_tag :span, block_given? ? capture(&block) : args[0], options
  end

  def svg_tag(name)
    file_path = "#{Rails.root}/app/assets/images/#{name}.svg"
    return '(not found)' unless File.exist?(file_path)
    File.read(file_path).html_safe
  end

  def table_tag(collection, &block)
    TableTag.new(self, collection, &block).render
  end
end
