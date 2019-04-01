module WithBreadcrumbs
  extend ActiveSupport::Concern

  included do
    helper_method :add_breadcrumb, :breadcrumbs

    def add_breadcrumb(label_ref, route)
      return if label_ref.blank? || route.blank?

      label = if label_ref.try(:model?) then label_ref.model_name.human(count: '')
              else label_ref
              end
      breadcrumbs << { label: label, route: route }
    end

    def breadcrumbs
      @breadcrumbs ||= []
    end
  end
end
