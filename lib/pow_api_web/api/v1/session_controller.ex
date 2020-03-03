defmodule PowApiWeb.API.V1.SessionController do
  use PowApiWeb, :controller

  alias PowApiWeb.APIAuthPlug

  @spec create(Conn.t(), map()) :: Conn.t()
  def create(conn, %{"user" => user_params}) do
    conn
    |> Pow.Plug.authenticate_user(user_params)
    |> case do
      {:ok, conn} ->
        if PowEmailConfirmation.Plug.email_unconfirmed?(conn) do
          Pow.Plug.delete(conn)
          |> put_status(401)
          |> json(%{error: %{status: 401, message: "Please register or confirm your registration email"}})
        else
          token_pair_json(conn)
        end

      {:error, conn} ->
        conn
        |> put_status(401)
        |> json(%{error: %{status: 401, message: "Invalid email or password"}})
    end
  end

  @spec renew(Conn.t(), map()) :: Conn.t()
  def renew(conn, _params) do
    config = Pow.Plug.fetch_config(conn)

    conn
    |> APIAuthPlug.renew(config)
    |> case do
      {conn, nil} ->
        conn
        |> put_status(401)
        |> json(%{error: %{status: 401, message: "Invalid Token"}})

      {conn, _user} ->
        token_pair_json(conn)
    end
  end

  defp token_pair_json(conn) do
    json(conn, %{data: %{auth_token: conn.private[:api_auth_token], renew_token: conn.private[:api_renew_token]}})
  end

  @spec delete(Conn.t(), map()) :: Conn.t()
  def delete(conn, _params) do
    Pow.Plug.delete(conn)
    |> json(%{data: %{}})
  end
end
