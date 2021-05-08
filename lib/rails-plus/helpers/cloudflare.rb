# frozen_string_literal: true

module RailsPlus
  module Helpers
    module Cloudflare
      def safe_email(email = nil, &block)
        "<!--email_off-->#{block_given? ? capture(&block) : email.to_s}<!--/email_off-->".html_safe
      end
    end
  end
end
