# frozen_string_literal: true

module RailsPlus::Controllers::RenderSimplePartial
  extend ActiveSupport::Concern

  private

  def render_simple_partial
    return if params[:partial].blank?
    return unless request.format.html?
    render partial: params[:partial], layout: false
    true
  end
end
