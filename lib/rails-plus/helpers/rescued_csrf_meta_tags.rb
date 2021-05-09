module RailsPlus
  module Helpers
    module RescuedCsrfMetaTags
      def rescued_csrf_meta_tags
        csrf_meta_tags
      rescue ArgumentError
        request.reset_session
        csrf_meta_tags
      end
    end
  end
end