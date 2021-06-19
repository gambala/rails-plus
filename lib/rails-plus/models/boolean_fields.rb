# frozen_string_literal: true

module RailsPlus::Models::BooleanFields
  extend ActiveSupport::Concern

  included do
    delegate :boolean_fields, to: :class
  end

  class_methods do
    def boolean_fields(*args)
      @boolean_fields = [] if @boolean_fields.blank?

      if args.empty?
        superclass_fields = superclass.respond_to?(:boolean_fields) ? superclass.boolean_fields : []
        return @boolean_fields + superclass_fields
      end

      options = args.extract_options!
      @boolean_fields += args

      args.each do |field|
        field_at = "#{field}_at"
        truthy = [true, 'true', '1', 1]

        scope     "#{field}", -> { where(field => true) }         # scope :approved
        scope "not_#{field}", -> { where(field => false) }        # scope :not_approved

        define_method(    "#{field}?") { self[field] == true }    # def approved?
        define_method("not_#{field}?") { self[field] == false }   # def not_approved?

        define_method("on_#{field}!") {}                          # def on_approved!

        define_method(field_at) do                                # def approved_at
          fallback_field = options[:fallback]
          return self[field_at] if fallback_field.blank?
          self[field_at].presence || self[fallback_field]
        end

        define_method("#{field}=") do |value|                     # def approved=(value)
          if self[field] == false && value.in?(truthy)
            self[field_at] = Time.zone.now
          end

          self[field] = value
        end

        define_method("set_#{field}!") do |value = true|          # def set_approved!(value = true)
          public_send("#{field}=", value)                         # self.approved = value
          public_send("on_#{field}!") if save                     # on_approved! if save
        end
      end
    end
  end
end
