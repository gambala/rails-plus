# frozen_string_literal: true

module WithLayoutProps
  extend ActiveSupport::Concern

  included do
    helper_method :layout_props
  end

  private

  def layout_props(props = nil)
    @layout_props = props if props.present?
    @layout_props || {}
  end

  module ClassMethods
    def layout_props(props = nil)
      before_action -> { layout_props(props) }
    end
  end
end
