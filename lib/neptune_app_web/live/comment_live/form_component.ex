defmodule NeptuneAppWeb.CommentLive.FormComponent do
  use NeptuneAppWeb, :live_component

  alias NeptuneApp.Research

  @impl true
  def render(assigns) do
    ~H"""
    <div>

      <.simple_form
        for={@form}
        id="comment-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:content]} type="textarea" label="Comment" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Comment</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{comment: comment} = assigns, socket) do
    changeset = Research.change_comment(comment)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"comment" => comment_params}, socket) do
    changeset =
      socket.assigns.comment
      |> Research.change_comment(comment_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"comment" => comment_params}, socket) do
    current_user =  socket.assigns[:current_user]
    experiment =  socket.assigns[:experiment]
    comment_params = Map.put(comment_params, "created_by", current_user)
    comment_params = Map.put(comment_params, "experiment", experiment)
    save_comment(socket, socket.assigns.action, comment_params)
  end

  defp save_comment(socket, :edit, comment_params) do
    case Research.update_comment(socket.assigns.comment, comment_params) do
      {:ok, comment} ->
        notify_parent({:saved, comment})

        {:noreply,
         socket
         |> put_flash(:info, "Comment updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_comment(socket, :new, comment_params) do
    case Research.create_comment(comment_params) do
      {:ok, comment} ->
        notify_parent({:saved, comment})

        Phoenix.PubSub.broadcast(NeptuneApp.PubSub,"experiments:#{comment.experiment_id}:comment_all", {comment.experiment_id, :comment_all})
        {:noreply,
         socket
         |> put_flash(:info, "Comment created successfully")
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
