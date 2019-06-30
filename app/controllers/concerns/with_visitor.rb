# frozen_string_literal: true

module WithVisitor
  extend ActiveSupport::Concern

  included do
    helper_method :visitor_id

    def visitor_id
      @visitor_id ||= cookies.encrypted[:visitor_id] ||= SecureRandom.uuid
    end
  end
end
