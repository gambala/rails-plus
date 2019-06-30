class TableTag
  attr_reader :view_context
  attr_reader :collection, :columns, :values, :column_titles

  def initialize(view_context, collection)
    @view_context = view_context
    @collection = collection
    @columns = []
    @values = {}
    @column_titles = {}
    yield self
  end

  def render
    view_context.render 'tag_table', columns: columns, values: values, collection: collection,
                                     column_titles: column_titles
  end

  def column(name, *args, &block)
    options = args.extract_options!
    skip_column = options[:if].present? ? !options[:if].call : false
    return if skip_column
    @columns += [name]
    @values[name] = block_given? ? block : options[:value]
    @column_titles[name] = options[:column_title] if options[:column_title]
  end
end
