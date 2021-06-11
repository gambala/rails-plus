# frozen_string_literal: true

module RailsPlus::Models::EmailField
  extend ActiveSupport::Concern

  def email=(value)
    result = value.nil? ? nil : value.downcase.squish
    super(result)
  end
end
