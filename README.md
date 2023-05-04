# Faraday Loop

Ever need a simple way to retry a block of code? Maybe you need a maximum number of retries? Exponential backoff? Different handling for different exceptions?

[Faraday](https://github.com/lostisland/faraday) has one!

But, while Faraday is one nice piece of kit, you might not be in the market for an http client like Faraday and all of its Middelware.

So we took the [Faraday Retry Middleware](https://github.com/lostisland/faraday-retry), and just simply cloned it into its own utility.

#### Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add faraday_loop

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install faraday_loop

#### Usage

You'll first need to require it:

```ruby
require 'faraday_loop'
```

Then, create a new instance of the retry utility, passing any options as needed:

```ruby
retry_utility = FaradayLoop::Retry.new(
  max: 3,
  interval: 1,
  max_interval: 10,
  interval_randomness: 0.5,
  backoff_factor: 2,
  exceptions: [MyCustomException],
  retry_if: ->(e) { e.is_a?(MyCustomException) },
  retry_block: ->(retries, e) { puts "Retry #{retries}: #{e.message}" }
)
```

- max: The maximum number of retries (default: 2)
- interval: The initial interval between retries in seconds (default: 0)
- max_interval: The maximum interval between retries in seconds (default: Float::MAX)
- interval_randomness: A factor to add randomness to the retry intervals (default: 0)
- backoff_factor: The factor to multiply the interval by for each retry (default: 1)
- exceptions: An array of exception classes to retry (default: Faraday::RetriableExceptions)
- retry_if: A lambda that returns true if the exception should be retried (default: checks if the exception is in the exceptions array)
- retry_block: An optional lambda that is called before each retry, passing in the current retry count and the exception raised

Finally, wrap the operation you want to retry in a block:

```ruby
retry_utility.call do
  # Your operation that might fail and require retries
end
```

You can also shortcut this with:

```ruby
retry_utility = FaradayLoop::Retry(
  options
).retry do
    # Your operation that might fail and require retries
end
```

#### License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

#### Feedback
[Source code available on Github](https://github.com/sutrolabs/faraday_loop). Feedback and pull requests are greatly appreciated. Let us know if we can improve this.

#### From
:wave: The folks at [lostisland](https://github.com/lostisland/faraday-retry) really made this. We at [Census](http://getcensus.com) just hoisted it up.

Interested in other things we do? **[Come work with us](https://www.getcensus.com/careers)**.
