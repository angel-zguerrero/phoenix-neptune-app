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
          options={NeptuneApp.Research.ScientificOperation.translated_types()}
        />
        <%= if  @currentType == :factorial || @currentType == "factorial" do %>
          <.input field={@form[:parameters_factorial_n]} type="number" min="0" step="1" label="n" />
        <% else %>
          <%= if  @currentType == :integral_trapezoidal || @currentType == "integral_trapezoidal" do %>
            <.input field={@form[:parameters_integral_trapezoidal_function]} type="textarea" label="f(x)" />
            <.input field={@form[:parameters_integral_trapezoidal_a]} type="number" step="any" label="Left limit" />
            <.input field={@form[:parameters_integral_trapezoidal_b]} type="number" step="any" label="Right limit" />
            <.input field={@form[:parameters_integral_trapezoidal_epsilon]} type="number" step="any" label="Epsilon" />

          <% else %>
            <.input field={@form[:parameters]} type="textarea" label="Parameters" />
          <% end%>
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

  def parse_to_float(value) do
    {float, _} = Float.parse(value)
    float
  end

  def parse_to_integer(value) do
    {integer, _} = Integer.parse(value)
    integer
  end

  defp save_scientific_operation(socket, :new, scientific_operation_params) do
    tyrant_api_base_url = Application.fetch_env!(:neptune_app, :tyrant_api_base_url)
    scientific_operation_payload_value = case scientific_operation_params["type"] do
      "factorial" -> parse_to_integer(scientific_operation_params["parameters_factorial_n"])
      "integral_trapezoidal" -> %{
        function: scientific_operation_params["parameters_integral_trapezoidal_function"],
        a: parse_to_float(scientific_operation_params["parameters_integral_trapezoidal_a"]),
        b: parse_to_float(scientific_operation_params["parameters_integral_trapezoidal_b"]),
        epsilon: parse_to_float(scientific_operation_params["parameters_integral_trapezoidal_epsilon"])
      }
      _ -> raise("bad type #{scientific_operation_params["type"]}")
    end
    scientific_operation_payload = %{operation: %{type: scientific_operation_params["type"], value: scientific_operation_payload_value}}
    body = Jason.encode!(scientific_operation_payload)
    IO.inspect("#{tyrant_api_base_url}/scientist-operator/solve")
    case HTTPoison.post("#{tyrant_api_base_url}/scientist-operator/solve",body, [{"Accept", "*/*"}, {"Content-Type", "application/json"}]) do
      {:ok, response} ->
        responseBody = Jason.decode!(response.body)
        scientific_operation_params = Map.put(scientific_operation_params, "parameters", Jason.encode!(scientific_operation_payload_value))
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
