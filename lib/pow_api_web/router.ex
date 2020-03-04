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

    post "/confirm-email", ConfirmEmailController, :confirm
    post "/resend-confirm-email", ConfirmEmailController, :resend_email
  end
end
