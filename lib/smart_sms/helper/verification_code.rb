require 'securerandom'

module SmartSMS
  module VerificationCode
    extend self
    def simple
      SecureRandom.random_number.to_s.slice(-6..-1)
    end

    def middle
      SecureRandom.base64.slice(1..6).downcase
    end

    def complex
      SecureRandom.base64.slice(1..8).downcase
    end
  end
end