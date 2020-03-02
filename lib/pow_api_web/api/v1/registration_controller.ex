defmodule PowApiWeb.API.V1.RegistrationController do
  use PowApiWeb, :controller

  alias Ecto.Changeset
  alias Plug.Conn
  alias PowApiWeb.ErrorHelpers

  @spec create(Conn.t(), map()) :: Conn.t()
  def create(conn, %{"user" => user_params}) do
    conn
    |> custom_create(user_params)
    |> case do
      {:ok, _user} ->
        #TODO: Send confirmation email here
        json(conn, %{data: %{message: "Please check your email"}})

      {:error, changeset} ->
        errors = Changeset.traverse_errors(changeset, &ErrorHelpers.translate_error/1)

        conn
        |> put_status(500)
        |> json(%{error: %{status: 500, message: "Couldn't create user", errors: errors}})
    end
  end

  defp custom_create(conn, user_params) do
    config = Pow.Plug.fetch_config(conn)

    user_params
    |> Pow.Operations.create(config)
  end
end
