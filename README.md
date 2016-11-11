# what3words Elixir wrapper

Use the what3words API in your Elixir app (see [the API documentation](http://developer.what3words.com/api)). 🚀

__Hey, version 2.0 is out! 🎶__ Have a look at the [hexdocs](https://hexdocs.pm/what3words) to see what's changed! 

## Installation

Pretty straightforward! Add the dependency to your `mix.exs`:
```
  def deps do
    [{:what3words, "~> 2.0.0"}]
  end
```

add `:what3words` to the applications to be started:
```
  def application do
    [applications: [:logger, :what3words]]
  end
```

and add your API key to your `config.exs` (get one [here](https://map.what3words.com/register?dev=true)):
```
config :what3words, key: "mykey"
```

You should be good to go! 👏🏻

## Usage

[Hexdocs to the rescue! 👋🏻](https://hexdocs.pm/what3words)

## Contributing

* Fork this repo
* Create your feature branch (`git checkout -b my-new-feature`)
* Commit your changes (`git commit -am 'Add some feature'`)
* Push to the branch (`git push origin my-new-feature`)
* Create a new Pull Request

## License

See [LICENSE](/LICENSE)
