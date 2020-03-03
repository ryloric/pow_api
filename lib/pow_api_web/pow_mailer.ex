defmodule PowApiWeb.PowMailer do
  use Pow.Phoenix.Mailer
  require Logger

  def cast(%{user: user, subject: subject, text: text, html: html, assigns: _assigns}) do
    %{to: user.email, subject: subject, text: text, html: html}
  end

  # TODO: Sub with the real thing.
  def process(email) do
    Logger.debug("Email sent: #{inspect email}")
  end
end
