# frozen_string_literal: true

require "test_helper"

class TestFaradayLoop < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::FaradayLoop::VERSION
  end

  def test_call
    retry_utility = FaradayLoop::Retry.new(
      max: 10,
      interval: 1,
      max_interval: 10,
      interval_randomness: 0.5,
      backoff_factor: 2
    )

    retry_utility.call do
      raise StandardError.new("Random error occurred") if rand <= 0.5
    end

    assert true
  end

  def test_call_shortcut
    FaradayLoop::Retry.retry(
      max: 0,
      interval: 0,
    ) do
      raise StandardError.new("Random error occurred") if rand <= 0.5

      assert true
    end
  end

end
