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
        <.input field={@form[:parameters]} type="textarea" label="Parameters" />
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
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"scientific_operation" => scientific_operation_params}, socket) do
    changeset =
      socket.assigns.scientific_operation
      |> Research.change_scientific_operation(scientific_operation_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"scientific_operation" => scientific_operation_params}, socket) do
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
    case Research.create_scientific_operation(scientific_operation_params) do
      {:ok, scientific_operation} ->
        notify_parent({:saved, scientific_operation})

        {:noreply,
         socket
         |> put_flash(:info, "Scientific operation created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
