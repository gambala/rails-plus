# frozen_string_literal: true

module RailsPlus::Models::VirtualBooleanFields
  extend ActiveSupport::Concern

  included do
    delegate :virtual_boolean_fields, to: :class
  end

  class_methods do
    def virtual_boolean_fields(*args)
      @virtual_boolean_fields = [] if @virtual_boolean_fields.blank?

      if args.empty?
        superclass_fields = superclass.respond_to?(:virtual_boolean_fields) ? superclass.virtual_boolean_fields : []
        return @virtual_boolean_fields + superclass_fields
      end

      options = args.extract_options!
      @virtual_boolean_fields += args

      args.each do |field|
        field_at = "#{field}_at"
        falsy = [false, 'false', '0', 0]
        truthy = [true, 'true', '1', 1]

        attribute field, :boolean                                     # attribute :approved, :boolean

        scope     "#{field}", -> { where.not(field_at => nil) }       # scope :approved
        scope "not_#{field}", -> { where(field_at => nil) }           # scope :not_approved

        define_method(    "#{field}" ) { !self[field_at].nil? }       # def approved
        define_method(    "#{field}?") { !self[field_at].nil? }       # def approved?
        define_method("not_#{field}" ) { self[field_at].nil? }        # def not_approved
        define_method("not_#{field}?") { self[field_at].nil? }        # def not_approved?

        define_method(field_at) do                                    # def approved_at
          fallback_field = options[:fallback]
          return self[field_at] if fallback_field.blank?
          self[field_at].presence || self[fallback_field]
        end

        define_method("#{field}=") do |value|                         # def approved=(value)
          self[field_at] = Time.zone.now if self[field_at].nil? && value.in?(truthy)
          self[field_at] = nil           if !self[field_at].nil? && value.in?(falsy)
        end

        # Self-written callback method and it's bang runner method

        define_method("on_#{field}!") {}                              # def on_approved!

        define_method("set_#{field}!") do |value = true|              # def set_approved!(value = true)
          public_send("#{field}=", value)                             #   self.approved = value
          public_send("on_#{field}!") if save                         #   on_approved! if save
        end

        define_method("set_#{field}_false") do                        # def set_approved_false
          public_send("#{field}=", false)                             #   self.approved = false
        end

        define_method("set_#{field}_true") do                         # def set_approved_true
          public_send("#{field}=", true)                              #   self.approved = true
        end

        # Dirty attributes methods

        define_method("saved_change_to_#{field}") do                  # def saved_change_to_approved
          was, now = public_send("saved_change_to_#{field_at}")       #   was, now = saved_change_to_approved_at
          [was.present?, now.present?]
        end

        define_method("#{field}_became_false?") do                    # def approved_became_false?
          was, now = public_send("saved_change_to_#{field}")          #   was, now = saved_change_to_approved
          was == true && now == false
        end

        define_method("#{field}_became_true?") do                     # def approved_became_true?
          was, now = public_send("saved_change_to_#{field}")          #   was, now = saved_change_to_approved
          was == false && now == true
        end
      end
    end
  end
end
