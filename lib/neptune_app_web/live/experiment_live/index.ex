defmodule NeptuneAppWeb.ExperimentLive.Index do
  use NeptuneAppWeb, :live_view

  alias NeptuneApp.Research
  alias NeptuneApp.Research.Experiment

  @impl true
  def mount(_params, _session, socket) do
    Phoenix.PubSub.subscribe(NeptuneApp.PubSub, "experiments:list")
    {:ok, stream(socket, :experiments, Research.list_experiments())}
  end


  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Experiment")
    |> assign(:experiment, Research.get_experiment!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Experiment")
    |> assign(:experiment, %Experiment{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Experiments")
    |> assign(:experiment, nil)
  end

  @impl true
  def handle_info({NeptuneAppWeb.ExperimentLive.FormComponent, {:saved, experiment}}, socket) do
    {:noreply, stream_insert(socket, :experiments, experiment)}
  end

  @impl true
  def handle_info(:experiments_list, socket) do
    {:noreply, stream(socket, :experiments, Research.list_experiments())}
  end

end
