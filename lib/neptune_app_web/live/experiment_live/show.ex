defmodule NeptuneAppWeb.ExperimentLive.Show do
  use NeptuneAppWeb, :live_view

  alias NeptuneApp.Research
  alias NeptuneApp.Research.ScientificOperation

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:open_scientific_operation, false)
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:experiment, Research.get_experiment!(id))
     |> assign(:scientific_operation, %ScientificOperation{})
    }

  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    experiment = Research.get_experiment!(id)
    {:ok, _} = Research.delete_experiment(experiment)
    {:noreply, push_redirect(socket, to: ~p"/experiments")}
  end

  @impl true
  def handle_event("open-scientific-operation-modal", _params, socket) do
    IO.inspect("open-scientific-operation-modal>>>")

    {:noreply, socket
    |> assign(:open_scientific_operation, true)}
  end


  defp page_title(:show), do: "Show Experiment"
  defp page_title(:edit), do: "Edit Experiment"

end
