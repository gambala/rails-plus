# frozen_string_literal: true

module WithLayoutProps
  extend ActiveSupport::Concern

  included do
    helper_method :layout_props

    def layout_props(props = nil)
      @layout_props = props if props.present?
      @layout_props || {}
    end

    def self.layout_props(props = nil)
      before_action -> { layout_props(props) }
    end
  end
end
