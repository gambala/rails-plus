# frozen_string_literal: true

module WithI18nFields
  extend ActiveSupport::Concern
  include ActionView::Helpers::TextHelper
  include I18nHelper

  included do
    has_many :i18n_translations, as: :record, dependent: :nullify

    scope :order_by_i18n, ->(field, direction = :asc, locale: I18n.locale) {
      joins(:i18n_translations).where(i18n_translations: { locale: locale, field: field })
                               .order("i18n_translations.value #{direction}")
    }

    scope :translated, ->(locale = I18n.locale) {
      ids = select { |record| record.translated?(locale) }.map(&:id)
      where(id: ids)
    }

    after_commit :create_translations, on: :create

    delegate :i18n_fields,      to: :class
    delegate :i18n_record_type, to: :class
    delegate :i18n_type,        to: :class
    delegate :i18n_types,       to: :class
  end

  private

  # Callbacks

  def create_translations
    I18nLanguage.all.pluck(:locale).each do |locale|
      i18n_fields.each do |field|
        I18nTranslation.where(record_type: i18n_record_type, record_id: id, field: field,
                              locale: locale).first_or_create!
      end
    end
  end

  # Virtual attributes

  def translated?(locale = I18n.locale)
    return false if i18n_fields.blank?
    i18n_fields.each { |field| return false if public_send("i18n_#{field}", locale).blank? }
    true
  end

  def translations=(value)
    return if value.blank?

    value.each do |locale, fields|
      fields.each do |field, translation|
        I18nTranslation.find_by(record_type: i18n_record_type, record_id: id, field: field,
                                locale: locale).update(value: translation)
      end
    end
  end

  module ClassMethods
    def i18n_fields(*args)
      @i18n_fields = [] if @i18n_fields.blank?

      if args.empty?
        @i18n_fields += superclass.i18n_fields if superclass.respond_to?(:i18n_fields)
        return @i18n_fields
      end

      options = args.extract_options!
      @i18n_types = {} if @i18n_types.blank?
      @i18n_fields += args

      args.each do |field|
        as = options[:as] || :string
        @i18n_types[field.to_sym] = as

        define_method("i18n_#{field}") do |locale = nil|
          i18n_t locale: locale, record: self, field: field, as: as
        end

        next unless I18nLanguage.table_exists?

        I18nLanguage.all.pluck(:locale).each do |locale|
          define_method("i18n_#{field}_#{locale}") do
            send("i18n_#{field}", locale)
          end

          define_method("i18n_#{field}_#{locale}=") do |value|
            I18nTranslation.find_by(record_type: i18n_record_type, record_id: id, field: field,
                                    locale: locale).update(value: value)
          end
        end
      end
    end

    def i18n_permitted_attributes
      result = []

      I18nLanguage.all.pluck(:locale).each do |locale|
        i18n_fields.each do |field|
          result.push("i18n_#{field}_#{locale}")
        end
      end

      result
    end

    def i18n_record_type
      table_name.classify
    end

    def i18n_type(field)
      @i18n_types[field.to_sym]
    end

    def i18n_types
      @i18n_types
    end
  end
end
