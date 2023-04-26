# frozen_string_literal: true

require_relative "faraday_loop/version"

module FaradayLoop
  class Error < StandardError; end

  # Clones the Faraday request retry middleware behavior.
  # (https://github.com/lostisland/faraday/blob/v1.3.1/lib/faraday/request/retry.rb)
  #
  # Allows us to apply this familiar retry/backoff machinery outside of Faraday.
  class Retry
    def self.retry(
      max: nil,
      interval: nil,
      max_interval: nil,
      interval_randomness: nil,
      backoff_factor: nil,
      exceptions: nil,
      retry_if: nil,
      retry_block: nil,
      &block
    )
      retry_handler =
        Retry.new(
          max: max,
          interval: interval,
          max_interval: max_interval,
          interval_randomness: interval_randomness,
          backoff_factor: backoff_factor,
          exceptions: exceptions,
          retry_if: retry_if,
          retry_block: retry_block
        )
      retry_handler.call(&block)
    end

    DEFAULT_EXCEPTIONS = [StandardError].freeze
    DEFAULT_CHECK = ->(_exception) { true }

    def initialize(
      max: nil,
      interval: nil,
      max_interval: nil,
      interval_randomness: nil,
      backoff_factor: nil,
      exceptions: nil,
      retry_if: nil,
      retry_block: nil
    )
      @max = max || 2
      @interval = interval || 0
      @max_interval = max_interval || Float::MAX
      @interval_randomness = interval_randomness || 0
      @backoff_factor = backoff_factor || 1
      @exceptions = Array(exceptions || DEFAULT_EXCEPTIONS)
      @retry_if = retry_if || DEFAULT_CHECK
      @retry_block = retry_block || proc { |_, _| }
    end

    def call(&block)
      retries = @max
      begin
        block.call
      rescue => e
        # Yes, we really want to catch all error types here; the caller is in
        # full control of which errors to retry.
        raise unless matched_error?(e)

        if retries.positive? && retry_request?(e)
          retries -= 1
          @retry_block.call(retries, e)
          if (sleep_amount = calculate_retry_interval(retries + 1))
            Kernel.sleep sleep_amount
            retry
          end
        end

        raise
      end
    end

    private

    def matched_error?(error)
      @exceptions.any? do |ex|
        if ex.is_a? Module
          error.is_a? ex
        else
          error.class.to_s == ex.to_s
        end
      end
    end

    def retry_request?(exception)
      @retry_if.call(exception)
    end

    def calculate_retry_interval(retries)
      retry_index = @max - retries
      current_interval = @interval * (@backoff_factor**retry_index)
      current_interval = [current_interval, @max_interval].min
      random_interval = rand * @interval_randomness.to_f * @interval
      current_interval + random_interval
    end
  end
end
