defmodule NeptuneAppWeb.WebhookController do
  use NeptuneAppWeb, :controller

  action_fallback NeptuneAppWeb.FallbackController

  def handle_notification(conn, notification) do
    IO.inspect("Notification received")
    IO.inspect(notification)
    conn
    |> put_status(:created)
    |> render(:show, webhook: %{ack: true})
  end

end
