module RailsPlus::Helpers::Hicon
  def hicon(name, *args)
    options = args.extract_options!
    heroicon name, options: options
  end
end
