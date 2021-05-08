module RailsPlus
  module Helpers
    module Dashed
      def dashed(word)
        word.tr('_', '-')
      end
    end
  end
end
