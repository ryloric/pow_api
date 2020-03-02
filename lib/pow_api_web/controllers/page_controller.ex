defmodule PowApiWeb.PageController do
  use PowApiWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
