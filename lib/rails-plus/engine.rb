module RailsPlus
  class Engine < ::Rails::Engine
    initializer 'rails-plus.include_view_helpers' do |app|
      ActiveSupport.on_load :action_view do
        include RoutesHelper
      end
    end
  end
end
