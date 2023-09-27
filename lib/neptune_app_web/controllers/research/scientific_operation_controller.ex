defmodule NeptuneAppWeb.ScientificOperationController do
  use NeptuneAppWeb, :controller

  alias NeptuneApp.Research
  alias NeptuneApp.Research.ScientificOperation

  def index(conn, _params) do
    scientific_operations = Research.list_scientific_operations()
    render(conn, :index, scientific_operations: scientific_operations)
  end

  def new(conn, _params) do
    changeset = Research.change_scientific_operation(%ScientificOperation{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"scientific_operation" => scientific_operation_params}) do
    case Research.create_scientific_operation(scientific_operation_params) do
      {:ok, scientific_operation} ->
        conn
        |> put_flash(:info, "Scientific operation created successfully.")
        |> redirect(to: ~p"/scientific_operations/#{scientific_operation}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    scientific_operation = Research.get_scientific_operation!(id)
    render(conn, :show, scientific_operation: scientific_operation)
  end

  def edit(conn, %{"id" => id}) do
    scientific_operation = Research.get_scientific_operation!(id)
    changeset = Research.change_scientific_operation(scientific_operation)
    render(conn, :edit, scientific_operation: scientific_operation, changeset: changeset)
  end

  def update(conn, %{"id" => id, "scientific_operation" => scientific_operation_params}) do
    scientific_operation = Research.get_scientific_operation!(id)

    case Research.update_scientific_operation(scientific_operation, scientific_operation_params) do
      {:ok, scientific_operation} ->
        conn
        |> put_flash(:info, "Scientific operation updated successfully.")
        |> redirect(to: ~p"/scientific_operations/#{scientific_operation}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, scientific_operation: scientific_operation, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    scientific_operation = Research.get_scientific_operation!(id)
    {:ok, _scientific_operation} = Research.delete_scientific_operation(scientific_operation)

    conn
    |> put_flash(:info, "Scientific operation deleted successfully.")
    |> redirect(to: ~p"/scientific_operations")
  end
end
