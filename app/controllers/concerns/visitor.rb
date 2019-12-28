# frozen_string_literal: true

# Deprecated (use WithVisitor 30.06.2019)
module Visitor
  extend ActiveSupport::Concern

  included do
    helper_method :visitor_id
  end

  private

  def visitor_id
    @visitor_id ||= cookies.encrypted[:visitor_id] ||= SecureRandom.uuid
  end
end
