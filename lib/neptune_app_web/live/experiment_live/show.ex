defmodule NeptuneAppWeb.ExperimentLive.Show do
  use NeptuneAppWeb, :live_view

  alias NeptuneApp.Research
  alias NeptuneApp.Research.ScientificOperation
  alias NeptuneApp.Research.Comment

  @impl true
  def mount(params, _session, socket) do
    Phoenix.PubSub.subscribe(NeptuneApp.PubSub, "experiments:#{params["id"]}:scientific_operation_all")
    Phoenix.PubSub.subscribe(NeptuneApp.PubSub, "experiments:#{params["id"]}:scientific_operations")
    Phoenix.PubSub.subscribe(NeptuneApp.PubSub, "experiments:#{params["id"]}:comment_all")
    Phoenix.PubSub.subscribe(NeptuneApp.PubSub, "experiments:#{params["id"]}")

    scientific_operations = Research.list_scientific_operations(params["id"]) |> map_scientific_operations
    comments = Research.list_comments(params["id"])
    {:ok, socket
    |> stream(:scientific_operations, scientific_operations)
    |> stream(:comments, comments)}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:open_scientific_operation, false)
     |> assign(:open_comment, false)
     |> assign(:open_scientific_operation_detail, false)
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:experiment, Research.get_experiment!(id))
     |> assign(:scientific_operation, %ScientificOperation{})
     |> assign(:comment, %Comment{})
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
    {:noreply, socket
    |> assign(:open_scientific_operation, true)}
  end

  @impl true
  def handle_event("open-scientific-operation-detail-modal", params, socket) do
    scientific_operation_detail = Research.get_scientific_operation!(params["scientific-operation-id"])
    scientific_operation_detail = Map.put(scientific_operation_detail, :duration_in_seconds, transform_duration_in_seconds(scientific_operation_detail.duration))
    scientific_operation_detail = Map.put(scientific_operation_detail, :servers_array, transform_servers_in_array(scientific_operation_detail.servers))
    {:noreply, socket
    |> assign(:open_scientific_operation_detail, true)
    |> assign(:scientific_operation_detail, scientific_operation_detail)}
  end

  @impl true
  def handle_event("open-comment-modal", _params, socket) do
    {:noreply, socket
    |> assign(:open_comment, true)}
  end

  @impl true
  def handle_info({NeptuneAppWeb.ScientificOperationLive.FormComponent, {:saved, scientific_operation}}, socket) do
    {:noreply, stream(socket, :scientific_operations, Research.list_scientific_operations(scientific_operation.experiment_id) |> map_scientific_operations)}
  end

  @impl true
  def handle_info({NeptuneAppWeb.ExperimentLive.FormComponent, {:saved, _experiment}}, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_info({NeptuneAppWeb.CommentLive.FormComponent, {:saved, comment}}, socket) do
    {:noreply, stream(socket, :comments, Research.list_comments(comment.experiment_id))}
  end

  @impl true
  def handle_info({experiment_id, :scientific_operation_all}, socket) do
    {:noreply, stream(socket, :scientific_operations, Research.list_scientific_operations(experiment_id) |> map_scientific_operations) }
  end


  @impl true
  def handle_info({experiment_id, :comment_all}, socket) do
    {:noreply, stream(socket, :comments, Research.list_comments(experiment_id))}
  end

  @impl true
  def handle_info(%{experiment_id: experiment_id}, socket) do
    experiment = Research.get_experiment!(experiment_id)
    {:noreply, socket
    |> assign(:experiment, experiment)}
  end

  @impl true
  def handle_info(%{scientific_operation_id: scientific_operation_id}, socket) do
    if Map.has_key?(socket.assigns, :scientific_operation_detail) && socket.assigns.scientific_operation_detail.id == scientific_operation_id do
      scientific_operation_detail = Research.get_scientific_operation!(scientific_operation_id)
      scientific_operation_detail = Map.put(scientific_operation_detail, :duration_in_seconds, transform_duration_in_seconds(scientific_operation_detail.duration))
      scientific_operation_detail = Map.put(scientific_operation_detail, :servers_array, transform_servers_in_array(scientific_operation_detail.servers))
      {:noreply, socket
      |> assign(:scientific_operation_detail, scientific_operation_detail)}
    else
      {:noreply, socket}
    end
  end

  defp map_scientific_operations (scientific_operations) do
    scientific_operations
    |> Enum.map(fn scientific_operation ->
      scientific_operation
      |> Map.put( :duration_in_seconds, transform_duration_in_seconds(scientific_operation.duration))
      |> Map.put( :servers_array, transform_duration_in_seconds(scientific_operation.duration))
    end)
  end

  defp transform_duration_in_seconds(duration) do
    if duration == :nil do
      "-"
    else
      duration / 1000
    end
  end

  defp transform_servers_in_array(servers) do
    if servers == :nil do
      []
    else
      Jason.decode!(servers)
    end
  end

  defp page_title(:show), do: "Show Experiment"
  defp page_title(:edit), do: "Edit Experiment"

end
