defmodule NeptuneAppWeb.ScientificOperationLive.FormComponent do
  use NeptuneAppWeb, :live_component

  alias NeptuneApp.Research

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage scientific_operation records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="scientific_operation-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input
          field={@form[:type]}
          type="select"
          label="Type"
          options={Ecto.Enum.values(NeptuneApp.Research.ScientificOperation, :type)}
        />
        <%= if  @currentType == :factorial || @currentType == "factorial" do %>
          <.input field={@form[:parameters]} type="number" label="Parameters" />
        <% else %>
        <.input field={@form[:parameters]} type="textarea" label="Parameters" />
        <% end%>
        <:actions>
          <.button phx-disable-with="Saving...">Save Scientific operation</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{scientific_operation: scientific_operation} = assigns, socket) do
    changeset = Research.change_scientific_operation(scientific_operation)
    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)
     |> assign(:currentType, scientific_operation.type)
    }
  end

  @impl true
  def handle_event("validate", %{"scientific_operation" => scientific_operation_params}, socket) do
    changeset =
      socket.assigns.scientific_operation
      |> Research.change_scientific_operation(scientific_operation_params)
      |> Map.put(:action, :validate)

    socket_assign =
      assign_form(socket, changeset)
      |> assign(currentType: scientific_operation_params["type"])
    {:noreply, socket_assign}
  end

  def handle_event("save", %{"scientific_operation" => scientific_operation_params}, socket) do
    current_user =  socket.assigns[:current_user]
    experiment =  socket.assigns[:experiment]
    scientific_operation_params = Map.put(scientific_operation_params, "created_by", current_user)
    scientific_operation_params = Map.put(scientific_operation_params, "experiment", experiment)
    save_scientific_operation(socket, socket.assigns.action, scientific_operation_params)
  end

  defp save_scientific_operation(socket, :edit, scientific_operation_params) do
    case Research.update_scientific_operation(socket.assigns.scientific_operation, scientific_operation_params) do
      {:ok, scientific_operation} ->
        notify_parent({:saved, scientific_operation})

        {:noreply,
         socket
         |> put_flash(:info, "Scientific operation updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_scientific_operation(socket, :new, scientific_operation_params) do
    tyrant_api_base_url = Application.fetch_env!(:neptune_app, :tyrant_api_base_url)
    scientific_operation_payload_value = case scientific_operation_params["type"] do
      "factorial" -> String.to_integer(scientific_operation_params["parameters"])
      _ -> raise("bad type #{scientific_operation_params["type"]}")
    end
    scientific_operation_payload = %{operation: %{type: scientific_operation_params["type"], value: scientific_operation_payload_value}}
    body = Jason.encode!(scientific_operation_payload)
    IO.inspect("sending operation to tyrant!")
    IO.inspect("#{tyrant_api_base_url}/scientist-operator/solve")
    case HTTPoison.post("#{tyrant_api_base_url}/scientist-operator/solve",body, [{"Accept", "*/*"}, {"Content-Type", "application/json"}]) do
      {:ok, response} ->

        responseBody = Jason.decode!(response.body)
        scientific_operation_params = Map.put(scientific_operation_params, "remoteId", responseBody["register"]["_id"])
        scientific_operation_params = Map.put(scientific_operation_params, "remoteStatus", responseBody["register"]["status"])
        scientific_operation_params = Map.put(scientific_operation_params, "remoteResult", response.body)
        case Research.create_scientific_operation(scientific_operation_params) do
          {:ok, scientific_operation} ->
            notify_parent({:saved, scientific_operation})
            Phoenix.PubSub.broadcast(NeptuneApp.PubSub,"experiments:#{scientific_operation.experiment_id}:scientific_operation_all", {scientific_operation.experiment_id, :scientific_operation_all})
            {:noreply,
            socket
            |> put_flash(:info, "Scientific operation created successfully")
            |> push_patch(to: socket.assigns.patch)}

          {:error, %Ecto.Changeset{} = changeset} ->
            {:noreply, assign_form(socket, changeset)}
        end

      {:error, response} ->
          {:noreply, socket
          |> put_flash(:error, "Error creating Scientific operation: #{inspect(response.reason)}")
          |> push_patch(to: socket.assigns.patch)}
    end



  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
