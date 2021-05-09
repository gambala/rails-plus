module RailsPlus::Helpers::Routes
  # rubocop:disable Lint/UnusedMethodArgument
  def resources_rich(*resources, &block)
    options = resources.dup.extract_options!

    resources(*resources) do
      yield if block_given?
      get   :delete          , on: :member if options_have_key?(options, :delete)
      get   :download        , on: :member if options_have_key?(options, :download)
      get   :invoice         , on: :member if options_have_key?(options, :invoice)
      get   :pdf             , on: :member if options_have_key?(options, :pdf)
      put   :undelete        , on: :member if options_have_key?(options, :undelete)
      patch :undelete        , on: :member if options_have_key?(options, :undelete)
      put   :update_position , on: :member if options_have_key?(options, :update_position)
      patch :update_position , on: :member if options_have_key?(options, :update_position)
      get   :mini            , on: :collection if options_have_key?(options, :mini)
      put   :batch           , on: :collection if options_have_key?(options, :batch)
      patch :batch           , on: :collection if options_have_key?(options, :batch)
    end
  end
  # rubocop:enable Lint/UnusedMethodArgument

  def scoped_resources(*resources, &block)
    module_name = resources[0]

    scope module: module_name do
      resources(*resources, &block)
    end
  end

  def scoped_resources_rich(*resources, &block)
    module_name = resources[0]

    scope module: module_name do
      resources_rich(*resources, &block)
    end
  end

  # Deprecated aliases

  def scoped_rich_resources(*resources, &block)
    scoped_resources_rich(*resources, &block)
  end

  def rich_resources(*resources, &block)
    resources_rich(*resources, &block)
  end

  private

  def options_have_key?(options, key)
    if options.key?(:only)
      options[:only].include?(key) ? true : false
    elsif options.key?(:except)
      options[:except].include?(key) ? false : true
    else
      true
    end
  end
end
