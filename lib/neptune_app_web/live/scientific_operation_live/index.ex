defmodule NeptuneAppWeb.ScientificOperationLive.Index do
  use NeptuneAppWeb, :live_view

  alias NeptuneApp.Research
  alias NeptuneApp.Research.ScientificOperation

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :scientific_operations, Research.list_scientific_operations())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Scientific operation")
    |> assign(:scientific_operation, Research.get_scientific_operation!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Scientific operation")
    |> assign(:scientific_operation, %ScientificOperation{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Scientific operations")
    |> assign(:scientific_operation, nil)
  end

  @impl true
  def handle_info({NeptuneAppWeb.ScientificOperationLive.FormComponent, {:saved, scientific_operation}}, socket) do
    {:noreply, stream_insert(socket, :scientific_operations, scientific_operation)}
  end

end
