defmodule NeptuneAppWeb.ScientificOperationLive.Show do
  use NeptuneAppWeb, :live_view

  alias NeptuneApp.Research

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:scientific_operation, Research.get_scientific_operation!(id))}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    scientific_operation = Research.get_scientific_operation!(id)
    {:ok, _} = Research.delete_scientific_operation(scientific_operation)
    {:noreply, push_redirect(socket, to: ~p"/scientific_operations")}
  end

  defp page_title(:show), do: "Show Scientific operation"
end
