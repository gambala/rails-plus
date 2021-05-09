# frozen_string_literal: true

module RailsPlus::Helpers::RenderBreadcrumbs
  def render_breadcrumbs
    return if breadcrumbs.empty?
    return if breadcrumbs.size == 1

    content_tag :div, class: 'breadcrumb-list' do
      breadcrumb = breadcrumbs[-2]
      concat link_to '', breadcrumb[:route], class: 'breadcrumb-list__link' if breadcrumb.present?

      breadcrumbs[0..-2].each do |breadcrumb|
        concat link_to breadcrumb[:label], breadcrumb[:route], class: 'breadcrumb-item'
      end
    end
  end
end
