module RailsPlus
  module Helpers
    module Hicon
      def hicon(name, *args)
        options = args.extract_options!
        heroicon name, options: options
      end
    end
  end
end
