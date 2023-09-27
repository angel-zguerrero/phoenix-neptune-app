defmodule NeptuneAppWeb.CollaboratorController do
  use NeptuneAppWeb, :controller

  alias NeptuneApp.Research
  alias NeptuneApp.Research.Collaborator

  def index(conn, _params) do
    collaborators = Research.list_collaborators()
    render(conn, :index, collaborators: collaborators)
  end

  def new(conn, _params) do
    changeset = Research.change_collaborator(%Collaborator{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"collaborator" => collaborator_params}) do
    case Research.create_collaborator(collaborator_params) do
      {:ok, collaborator} ->
        conn
        |> put_flash(:info, "Collaborator created successfully.")
        |> redirect(to: ~p"/collaborators/#{collaborator}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    collaborator = Research.get_collaborator!(id)
    render(conn, :show, collaborator: collaborator)
  end

  def edit(conn, %{"id" => id}) do
    collaborator = Research.get_collaborator!(id)
    changeset = Research.change_collaborator(collaborator)
    render(conn, :edit, collaborator: collaborator, changeset: changeset)
  end

  def update(conn, %{"id" => id, "collaborator" => collaborator_params}) do
    collaborator = Research.get_collaborator!(id)

    case Research.update_collaborator(collaborator, collaborator_params) do
      {:ok, collaborator} ->
        conn
        |> put_flash(:info, "Collaborator updated successfully.")
        |> redirect(to: ~p"/collaborators/#{collaborator}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, collaborator: collaborator, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    collaborator = Research.get_collaborator!(id)
    {:ok, _collaborator} = Research.delete_collaborator(collaborator)

    conn
    |> put_flash(:info, "Collaborator deleted successfully.")
    |> redirect(to: ~p"/collaborators")
  end
end
