[![CircleCI](https://circleci.com/gh/rainforestapp/http-exceptions.svg?style=svg)](https://circleci.com/gh/rainforestapp/http-exceptions)

# Http::Exceptions

Http::Exceptions provides an easy way to rescue exceptions that might be thrown by your Http library. This was developed at Rainforest QA - you can read more in [Introducing Http::Exceptions](https://www.rainforestqa.com/blog/2014-08-15-introducing-http-exceptions/) over on our blog.

If you're using a library such as the excellent [HTTParty](https://github.com/jnunemaker/httparty), you still have to deal with various types of exceptions. In an ideal world, the return code of the HTTP request would be the sole indicator of failures, but HTTP libraries can raise a large number of exceptions (such as `SocketError` or `Net::ReadTimeout`) that you need to handle.

Http::Exceptions converts any error that might be raised by your HTTP library and wrap it in a `Http::Exceptions::HttpException`.

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
response = Http::Exceptions.wrap_exception do
  HTTParty.get "http://www.google.com"
end
```

Raise an exception if the return code of the API call is not `2XX`.

```ruby
response = Http::Exceptions.wrap_and_check do
  HTTParty.get "http://www.google.com"
end
```

You can then rescue the exception in the following way:

```ruby
begin
  response = Http::Exceptions.wrap_and_check do
    HTTParty.get "http://www.google.com"
  end
rescue Http::Exceptions::HttpException => e
  # ...
end
```

### Support

Currently, this only has been tested with HTTParty. It should however work with any library that delegates to the ruby http library.

## Contributing

1. Fork it ( https://github.com/rainforestapp/http-exceptions/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
