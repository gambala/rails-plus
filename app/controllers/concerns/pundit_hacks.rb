module PunditHacks
  extend ActiveSupport::Concern

  included do
    helper_method :authorized
  end

  private

  def authorized(*args)
    policy_scope(*args)
  end
end
