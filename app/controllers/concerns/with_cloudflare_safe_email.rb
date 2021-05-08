# frozen_string_literal: true

module WithCloudflareSafeEmail
  extend ActiveSupport::Concern

  included do
    helper_method :safe_email
  end

  private

  def safe_email(email = nil, &block)
    "<!--email_off-->#{block_given? ? capture(&block) : email.to_s}<!--/email_off-->".html_safe
  end
end
