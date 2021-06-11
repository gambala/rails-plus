# frozen_string_literal: true

module RailsPlus::Controllers::InvisibleCaptcha
  extend ActiveSupport::Concern

  def invisible_captcha_verified?(honeypot: :surname)
    return false if honeypot_spam?(honeypot: honeypot)
    return true if timestamp_spam?
    return true if spinner_spam?
    true
  end
end
