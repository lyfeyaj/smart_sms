require 'securerandom'

module SmartSMS
  # This module provides some methods to generate random verification code
  #
  # Algorithm:
  #
  #   * short:    Generate short code with 4 numbers
  #   * simple:   Generate simple code with 6 numbers
  #   * middle:   Generate middle complex code of 6 charactors with mixed numbers and letters
  #   * complex:  Generate complex code of 8 charactors with mixed numbers, letters or special charactors
  module VerificationCode
    module_function

    REGISTERED_ALGORITHMS = [:short, :simple, :middle, :complex]

    def random(algorithm = '')
      algorithm = SmartSMS.config.verification_code_algorithm if algorithm.blank?
      if REGISTERED_ALGORITHMS.include? algorithm
        SmartSMS::VerificationCode.send algorithm
      else
        fail NoMethodError
      end
    end

    def short
      SecureRandom.random_number.to_s.slice(-4..-1)
    end

    def simple
      SecureRandom.random_number.to_s.slice(-6..-1)
    end

    def middle
      SecureRandom.base64.gsub!(/[^0-9a-zA-Z]/, '').slice(1..6).downcase
    end

    def complex
      SecureRandom.base64.slice(1..8).downcase
    end
  end
end
