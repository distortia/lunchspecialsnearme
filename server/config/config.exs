# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :lsnm,
  ecto_repos: [Lsnm.Repo]

# Configures the endpoint
config :lsnm, LsnmWeb.Endpoint,
  url: [host: System.get_env("API_SERVER_HOST") || "localhost"],
  secret_key_base: "8kOv/wXh7pE8SFxVoxs8jSgTtg5Lbh82RtRusQJ64ZNUW6a2B+f3XMeASlDaQ1FJ",
  render_errors: [view: LsnmWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Lsnm.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :google_maps,
  api_key: "AIzaSyDjQ8EaxN_kXUvdx0BHh055I1FeL18urPQ"

# Configures Bamboo Mailer
config :lsnm, LsnmWeb.Mailer,
  adapter: Bamboo.SendgridAdapter,
  api_key: "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"

# guardian config
config :lsnm, LsnmWeb.Guardian,
  issuer: "LSNM",
  secret_key: "You really don't understand Ugandan culture, do you? You think it's all about 'de way' because you saw a stupid fucking shitty video made by a 12 year old on YouTube. Ugandan people don't deserve your white trash so-called 'memes' meant to continue the harassment and oppression of Africans. Fuck you and your white supremacy. When Oprah is president, I honest to God hope she vows to make white people a minority in your own fucking country. Or wherever you dumb little 'edgy' cunts are living. Either your country will drown by higher fertility rate by minorities or you will be fucked in the ass by your own backwards redneck culture. Now you're going to reply about how mad I am. Surprising, I am. I am INSULTED by your racist 'memes'. You think Uganada is all about shitty action movies, big black cock, and poor black people right? WRONG. Uganda is really one of the most culturally diverse and enriched places on Earth. And you just made a grave mistake by poking fun at the wrong culture. You want to 'kno de way', come meet me outside bitch.",
  token_ttl: %{ :access => { 30, :days } }

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
