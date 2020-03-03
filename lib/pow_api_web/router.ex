defmodule PowApiWeb.Router do
  use PowApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug PowApiWeb.APIAuthPlug, otp_app: :pow_api
  end

  pipeline :protected do
    plug Pow.Plug.RequireAuthenticated, error_handler: PowApiWeb.APIAuthErrorHandler
  end

  scope "/api/v1", PowApiWeb.API.V1 do
    pipe_through :api

    resources "/registration", RegistrationController, singleton: true, only: [:create]
    resources "/session", SessionController, singleton: true, only: [:create, :delete]
    post "/session/renew", SessionController, :renew

    resources "/confirm-email", ConfirmationController, only: [:show]
    post "/resend-confirm-email", ResendConfirmEmailController, :resend_email
  end
end
