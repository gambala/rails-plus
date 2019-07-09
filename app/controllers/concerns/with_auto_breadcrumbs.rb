module WithAutoBreadcrumbs
  extend ActiveSupport::Concern

  included do
    def auto_breadcrumbs(model, only: %i(index new show edit delete), prefix: [])
      @model = model

      only.each do |action|
        case action
        when :create, :update, :destroy
          next
        when :index
          add_breadcrumb model, prefix + [model.model_name.route_key] # User, [:prefix, :users]
        when :show
          return unless model_record.try(:persisted?)                 # unless user.try(:persisted?)
          add_breadcrumb model_record.to_s, prefix + [model_record]   # user.to_s, [:prefix, user]
        else
          actions = case action
                    when :new    then %i(new create)
                    when :edit   then %i(edit update)
                    when :delete then %i(delete destroy)
                                 else [action]
                    end
          next unless actions.include?(params[:action].to_sym)
          route = action == :new ? model.model_name.singular_route_key : model_record
          add_breadcrumb t("labels.breadcrumbs.#{action}"), [action] + prefix + [route]
        end
      end
    end

    private

    def model_element
      @model_element ||= @model.model_name.element
    end

    def model_record
      @model_record ||= begin
        method_name = model_element if self.class.private_method_defined?(model_element)
        method_name ||= 'record'
        self.send(method_name)
      end
    end
  end
end
