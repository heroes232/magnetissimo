# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :magnetissimo,
  ecto_repos: [Magnetissimo.Repo]

# Configures the endpoint
config :magnetissimo, Magnetissimo.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "ynsOOWObIkvMqh/9UFSwNzlS7kqto1Bi5jHLuwm0ssS90bUNyyX1dQY/RpwIwEDb",
  render_errors: [view: Magnetissimo.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Magnetissimo.PubSub,
           adapter: Phoenix.PubSub.PG2]

config :scrivener_html,
  routes_helper: Magnetissimo.Router.Helpers           

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Configure exq
config :exq,
  host: System.get_env("REDIS_HOST") || "127.0.0.1",
  port: String.to_integer(System.get_env("REDIS_PORT") || "6379"),
  namespace: "exq",
  queues: [
    {"eztv", 25},
    {"thepiratebay", 25},
    {"demonoid", 25}, 
    {"isohunt", 25},
    {"limetorrents", 25},
    {"torrentdownloads", 25},
    {"leetx", 25},
  ]

# Configure exq_ui
config :exq_ui,
  webport: 4040,
  web_namespace: "",
  server: true  

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
