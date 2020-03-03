defmodule PowApiWeb.API.V1.ResendConfirmEmailController do
  use PowApiWeb, :controller

  @spec resend_email(Conn.t(), map()) :: Conn.t()
  def resend_email(conn, %{"email" => email}) do
    config = Pow.Plug.fetch_config(conn)

    case Pow.Operations.get_by([email: email], config) do
      nil ->
        # This feels weird, should error out somehow.
        json(conn, %{data: %{message: "Email not registered"}})

      user ->
        config = Pow.Plug.fetch_config(conn)
        conn = Pow.Plug.assign_current_user(conn, user, config)

        if PowEmailConfirmation.Plug.email_unconfirmed?(conn) do
          resend_email_helper(user, conn)
          json(conn, %{data: %{message: "Email re-sent"}})
        else
          json(conn, %{data: %{message: "Email already verified"}})
        end

    end
  end

  # TODO Refactor this out.
  defp resend_email_helper(user, conn) do
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
