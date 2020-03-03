# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :pow_api,
  ecto_repos: [PowApi.Repo]

# Configures the endpoint
config :pow_api, PowApiWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "7KZbzLZEqcxUnSg9MJoH/i4Z0w0pIjtjmKp+1pJLz59O01likqYLq0VbRZSHAFgL",
  render_errors: [view: PowApiWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: PowApi.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [signing_salt: "29bbuQVS"],
  front_end_email_confirm_url: "http://localhost:1234/confirm-email/{token}"

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Configures POW
config :pow_api, :pow,
  user: PowApi.Users.User,
  repo: PowApi.Repo,
  mailer_backend: PowApiWeb.PowMailer,
  extensions: [PowEmailConfirmation, PowResetPassword],
  controller_callbacks: Pow.Extension.Phoenix.ControllerCallbacks

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
