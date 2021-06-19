module RailsPlus::Helpers::Hicon
  def hicon(name, *args)
    options = args.extract_options!
    params = {}
    params[:options] = options if options.present?
    params[:variant] = options[:variant] if options.present? && options[:variant].present?
    heroicon name, params
  end
end
