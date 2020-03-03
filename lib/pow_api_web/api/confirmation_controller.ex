defmodule PowApiWeb.API.V1.ConfirmationController do
  use PowApiWeb, :controller

  alias Plug.Conn

  @spec show(Conn.t(), map()) :: Conn.t()
  def show(conn, %{"id" => token}) do
    case PowEmailConfirmation.Plug.confirm_email(conn, token) do
      {:ok, _user, conn} ->
        conn
        |> json(%{data: %{message: "Email confirmed"}})

      {:error, _changeset, conn} ->
        conn
        |> put_status(401)
        |> json(%{error: %{status: 401, message: "Invalid confirmation code"}})
    end
  end
end
