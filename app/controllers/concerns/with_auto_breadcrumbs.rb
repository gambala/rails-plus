module WithAutoBreadcrumbs
  extend ActiveSupport::Concern

  included do
    def auto_breadcrumbs(model, only: %i(index new show edit delete), prefix: [])
      only.each do |action|
        case action
        when :create, :update, :destroy
          next
        when :index
          # add_breadcrumb User, [:prefix, :users]
          add_breadcrumb model, prefix + [model.model_name.route_key]
        when :show
          # add_breadcrumb user.to_s, [:prefix, user] if user.try(:persisted?)
          method_name = if self.class.private_method_defined?(model.model_name.element)
                          model.model_name.element
                        else
                          'record'
                        end
          record = self.send(method_name)
          add_breadcrumb record.to_s, prefix + [record] if record.try(:persisted?)
        else
          actions = case action
                    when :new    then %i(new create)
                    when :edit   then %i(edit update)
                    when :delete then %i(delete destroy)
                                 else [action]
                    end

          next unless actions.include?(params[:action].to_sym)

          if action == :new
            route = model.model_name.singular_route_key
          else
            method_name = 'record' if self.class.private_method_defined?('record')
            method_name ||= model.model_name.element
            record = self.send(method_name)
            route = record
          end

          add_breadcrumb t("labels.breadcrumbs.#{action}"), [action] + prefix + [route]
        end
      end
    end
  end
end
