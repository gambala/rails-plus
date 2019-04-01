module PunditHacks
  extend ActiveSupport::Concern

  included do
    helper_method :authorized

    def authorized(*args)
      policy_scope(*args)
    end
  end
end
