# frozen_string_literal: true

require "test_helper"

class TestFaradayLoop < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::FaradayLoop::VERSION
  end

  def test_call
    failed_once = false
    succeeded_once = false

    retry_utility = FaradayLoop::Retry.new(
      max: 10,
      interval: 1,
      max_interval: 10,
      interval_randomness: 0.5,
      backoff_factor: 2
    )

    retry_utility.call do
      if !failed_once
        failed_once = true
        raise StandardError.new("error occurred")
      end

      succeeded_once = true
    end

    assert succeeded_once
  end

  def test_call_shortcut
    failed_once = false
    succeeded_once = false

    FaradayLoop::Retry.retry(
      max: 1,
      interval: 0,
    ) do

      if !failed_once
        failed_once = true
        raise StandardError.new("error occurred")
      end

      succeeded_once = true
    end

    assert succeeded_once
  end
end
