module RailsPlus::Helpers::I18nHelper
  def formatted(value, as = :string)
    return nil if value.blank?

    case as
    when :integer
      return value.to_i
    when :html
      return value.html_safe
    else
      return value.in_time_zone if value.is_a?(Time)

      if value.is_a?(String)
        return value.html_safe if value.include?('<p>')
        return simple_format(value) if value.include?("\n")
      end

      value
    end
  end

  def t(key, options = {})
    result = super(key, options)
    result = super(key, options.merge(locale: I18n.default_locale)) if result.blank?
    formatted result
  end

  def i18n_t(options = {})
    locale = options[:locale] || I18n.locale
    result = I18nTranslation.find_by(locale: locale, record: options[:record], field: options[:field]).try(:value)

    if result.blank? && options[:locale].blank?
      locale = I18n.default_locale
      result = I18nTranslation.find_by(locale: locale, record: options[:record], field: options[:field]).try(:value)
    end

    formatted result, options[:as]
  end
end
