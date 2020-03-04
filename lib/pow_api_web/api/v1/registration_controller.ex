defmodule PowApiWeb.API.V1.RegistrationController do
  use PowApiWeb, :controller

  alias Ecto.Changeset
  alias Plug.Conn
  alias PowApiWeb.ErrorHelpers

  @spec create(Conn.t(), map()) :: Conn.t()
  def create(conn, %{"user" => user_params}) do
    user_params
    |> Pow.Ecto.Context.create(repo: PowApi.Repo, user: PowApi.Users.User)
    |> case do
      {:ok, user} ->
        send_confirmation_email(user, conn)
        conn
        |> put_status(201)
        |> json(%{data: %{message: "Please check your email"}})

      {:error, changeset} ->
        errors = Changeset.traverse_errors(changeset, &ErrorHelpers.translate_error/1)

        conn
        |> put_status(500)
        |> json(%{error: %{status: 500, message: "Couldn't create user", errors: errors}})
    end
  end

  defp send_confirmation_email(user, conn) do
    url = confirmation_url(user.email_confirmation_token)
    unconfirmed_user = %{user | email: user.unconfirmed_email || user.email}
    email = PowEmailConfirmation.Phoenix.Mailer.email_confirmation(conn, unconfirmed_user, url)

    Pow.Phoenix.Mailer.deliver(conn, email)
  end

  defp confirmation_url(token) do
    Application.get_env(:pow_api, PowApiWeb.Endpoint)[:front_end_email_confirm_url]
    |> String.replace("{token}", token)
  end
end
