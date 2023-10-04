defmodule NeptuneAppWeb.WebhookController do
  use NeptuneAppWeb, :controller

  action_fallback NeptuneAppWeb.FallbackController

  def handle_notification(conn, notification) do
    Enum.each(notification["operation_ids"], fn(operation_id) ->
      NeptuneAppWeb.TyrantApi.TyrantApiIntegration.processOperationUpdate(operation_id)
    end)
    conn
    |> put_status(:created)
    |> render(:show, webhook: %{ack: true})
  end

end
