# Http::Exceptions

Http::Exceptions provides an easy way to rescue exceptions that might be thrown by your Http library.

## Installation

Add this line to your application's Gemfile:

    gem 'http-exceptions'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install http-exceptions

## Usage

Only rescue raised exceptions.

```ruby
  Http::Exceptions.wrap_exception do
    Httparty.get "http://www.google.com"
  end
```

Raise an exception is the return code of the API call is not `2XX`.

```ruby
  Http::Exceptions.wrap_and_check do
    Httparty.get "http://www.google.com"
  end
```

### Support

Currently, this only has been tested with HTTP party. It could however be easily extended for other libraries as most of them just delegate to the ruby http library.

## Contributing

1. Fork it ( https://github.com/[my-github-username]/http-exceptions/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
