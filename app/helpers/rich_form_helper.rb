module RichFormHelper
  def rich_form_for(record, options = {}, &block)
    options[:authenticity_token] = true unless options.key?(:authenticity_token)
    options[:remote] = true unless options.key?(:remote)
    options[:html] = {} unless options.key?(:html)
    options[:html][:id] = 'form' unless options[:html].key?(:id)
    form_for(record, options.merge(builder: RichFormBuilder), &block)
  end
end
