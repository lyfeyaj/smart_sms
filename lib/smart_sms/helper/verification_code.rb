require 'securerandom'

module SmartSMS
  module VerificationCode
    extend self

    REGISTERED_ALGORITHMS = [:simple, :middle, :cmoplex]

    def random algorithm = :simple
      algorithm = SmartSMS.config.verification_code_algorithm if algorithm.blank?
      if REGISTERED_ALGORITHMS.include? algorithm
        SmartSMS::VerificationCode.send algorithm
      else
        raise NoMethodError
      end
    end

    private

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